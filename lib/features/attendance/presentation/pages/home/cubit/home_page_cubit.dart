import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import 'package:attendly/features/attendance/domain/entity/attendance_entity.dart';
import 'package:attendly/features/attendance/domain/entity/location_entity.dart';
import 'package:attendly/features/attendance/domain/repository/attendance_repository.dart';
import 'package:attendly/features/attendance/domain/usecases/check_in_use_case.dart';
import 'package:attendly/features/attendance/domain/usecases/check_out_use_case.dart';
import 'package:attendly/features/attendance/domain/usecases/get_last_attendance_log_use_case.dart';
import 'package:attendly/features/attendance/domain/usecases/sync_offline_attendance_use_case.dart';
import 'package:attendly/core/services/location_service.dart';
import 'package:attendly/core/services/snack_shower.dart';
import 'package:attendly/features/auth/domain/entity/user_entity.dart';
import 'package:attendly/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:attendly/features/auth/presentation/cubit/authentication_state.dart';

part 'home_page_cubit.freezed.dart';
part 'home_page_state.dart';

@injectable
class HomePageCubit extends Cubit<HomeState> {
  final AuthenticationCubit _auth;
  final LocationService _locationService;
  final CheckInUseCase _checkInUseCase;
  final CheckOutUseCase _checkOutUseCase;
  final SyncOfflineAttendanceUseCase _syncOfflineUseCase;
  final GetLastAttendanceLogUseCase _getLastAttendanceLogUseCase;
  final AttendanceRepository _attendanceRepository;
  final ISnackShower _snackShower;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _liveClockTimer;

  HomePageCubit(
    this._auth,
    this._locationService,
    this._checkInUseCase,
    this._checkOutUseCase,
    this._syncOfflineUseCase,
    this._getLastAttendanceLogUseCase,
    this._attendanceRepository,
    this._snackShower,
  ) : super(const HomeState.initial(isLoading: true)) {
    init();
  }

  void init() async {
    await syncOffline();
    await fetchLastAttendanceStatus();
    await checkConnectivityAndUnsynced();
    await fetchLocationAndStatus();
    _startLiveClock();
    _listenToConnectivity();
  }

  void _startLiveClock() {
    _liveClockTimer?.cancel();
    _liveClockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      if (state.checkInTime != null && state.isCheckedIn) {
        final elapsed = DateTime.now().difference(state.checkInTime!).inSeconds;
        emit(state.copyWith(elapsedSeconds: elapsed));
      } else {
        emit(state.copyWith());
      }
    });
  }

  Future<void> checkConnectivityAndUnsynced() async {
    final connectivity = await Connectivity().checkConnectivity();
    final isOffline = connectivity.contains(ConnectivityResult.none);
    final countRes = await _attendanceRepository.getUnsyncedCount();

    int unsyncedCount = 0;
    countRes.onSuccess((cnt) => unsyncedCount = cnt);

    if (!isClosed) {
      emit(state.copyWith(isOffline: isOffline, unsyncedCount: unsyncedCount));
    }
  }

  Future<void> fetchLastAttendanceStatus() async {
    UserEntity? user = _auth.currentUser;

    if (user == null) {
      final authState = _auth.state;
      if (authState is AuthenticationLoading) {
        await _auth.stream.firstWhere((s) => s is! AuthenticationLoading);
        user = _auth.currentUser;
      }
    }

    if (user == null) return;

    final res = await _getLastAttendanceLogUseCase.call(user.uid);
    if (isClosed) return;

    res.onSuccess((lastLog) {
      if (lastLog == null) return;

      final isCheckedIn = lastLog.type == AttendanceType.checkIn;
      emit(state.copyWith(
        isCheckedIn: isCheckedIn,
        lastLog: lastLog,
        checkInTime: isCheckedIn ? lastLog.timestamp : null,
      ));
    });
  }

  void _listenToConnectivity() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) async {
      final isOffline = results.contains(ConnectivityResult.none);
      if (!isOffline) {
        await _syncOfflineUseCase.call(null);
        await fetchLastAttendanceStatus();
      }
      await checkConnectivityAndUnsynced();
    });
  }

  Future<void> syncOffline() async {
    await _syncOfflineUseCase.call(null);
    await checkConnectivityAndUnsynced();
  }

  Future<void> fetchLocationAndStatus() async {
    emit(state.copyWith(isLoading: true));

    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();

    final isPermissionDenied = permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever;

    if (!isGpsEnabled || isPermissionDenied) {
      emit(state.copyWith(
        isLoading: false,
        isGpsDisabled: !isGpsEnabled,
        isPermissionDenied: isPermissionDenied,
      ));
    }

    final locRes = await _locationService.getCurrentLocation();
    if (isClosed) return;

    locRes
      ..onSuccess((location) {
        emit(state.copyWith(
          isLoading: false,
          currentLocation: location,
          isGpsDisabled: false,
          isPermissionDenied: false,
        ));
      })
      ..onError((failure) {
        emit(state.copyWith(isLoading: false));
        _snackShower.error(message: failure.reason);
      });
  }

  void openLocationSettings() async {
    await Geolocator.openLocationSettings();
    await fetchLocationAndStatus();
  }

  void openAppSettings() async {
    await Geolocator.openAppSettings();
    await fetchLocationAndStatus();
  }

  void toggleCheckInOut() async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (state.currentLocation == null) {
      _snackShower.error(message: 'Location not available yet.');
      return;
    }

    emit(state.copyWith(isLoading: true));

    if (state.isCheckedIn) {
      final res = await _checkOutUseCase.call(
        CheckOutParam(userId: user.uid, location: state.currentLocation!),
      );
      if (isClosed) return;
      res
        ..onSuccess((log) async {
          _snackShower.success(message: 'Checked out successfully!');
          emit(state.copyWith(
            isLoading: false,
            isCheckedIn: false,
            lastLog: log,
            checkInTime: null,
            elapsedSeconds: 0,
          ));
          await checkConnectivityAndUnsynced();
        })
        ..onError((failure) {
          emit(state.copyWith(isLoading: false));
          _snackShower.error(message: failure.reason);
        });
    } else {
      final res = await _checkInUseCase.call(
        CheckInParam(userId: user.uid, location: state.currentLocation!),
      );
      if (isClosed) return;
      res
        ..onSuccess((log) async {
          final now = DateTime.now();
          _snackShower.success(message: 'Checked in successfully!');
          emit(state.copyWith(
            isLoading: false,
            isCheckedIn: true,
            lastLog: log,
            checkInTime: now,
            elapsedSeconds: 0,
          ));
          await checkConnectivityAndUnsynced();
        })
        ..onError((failure) {
          emit(state.copyWith(isLoading: false));
          _snackShower.error(message: failure.reason);
        });
    }
  }

  @override
  Future<void> close() {
    _liveClockTimer?.cancel();
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
