import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:attendly/core/services/snack_shower.dart';
import 'package:attendly/features/attendance/domain/entity/attendance_entity.dart';
import 'package:attendly/features/attendance/domain/usecases/get_user_history_use_case.dart';
import 'package:attendly/features/auth/domain/entity/user_entity.dart';
import 'package:attendly/features/auth/presentation/cubit/authentication_cubit.dart';
import 'package:attendly/features/auth/presentation/cubit/authentication_state.dart';

part 'user_history_cubit.freezed.dart';
part 'user_history_state.dart';

@injectable
class UserHistoryCubit extends Cubit<UserHistoryState> {
  final AuthenticationCubit _auth;
  final GetUserHistoryUseCase _getUserHistoryUseCase;
  final ISnackShower _snackShower;

  UserHistoryCubit(
    this._auth,
    this._getUserHistoryUseCase,
    this._snackShower,
  ) : super(const UserHistoryState.initial()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    UserEntity? user = _auth.currentUser;

    if (user == null) {
      final authState = _auth.state;
      if (authState is AuthenticationLoading) {
        emit(const UserHistoryState.loading());
        await _auth.stream.firstWhere((s) => s is! AuthenticationLoading);
        user = _auth.currentUser;
      }
    }

    if (user == null) {
      emit(const UserHistoryState.error(error: 'User not logged in.'));
      return;
    }

    if (state is! UserHistoryReady) {
      emit(const UserHistoryState.loading());
    }

    final connectivity = await Connectivity().checkConnectivity();
    final isOffline = connectivity.contains(ConnectivityResult.none);

    final res = await _getUserHistoryUseCase.call(user.uid);
    if (isClosed) return;

    res
      ..onSuccess((logs) {
        final synced = logs.where((l) => l.isSynced).toList();
        final unsynced = logs.where((l) => !l.isSynced).toList();

        emit(UserHistoryState.ready(
          logs: logs,
          syncedLogs: synced,
          unsyncedLogs: unsynced,
          isOffline: isOffline,
          unsyncedCount: unsynced.length,
        ));
      })
      ..onError((failure) {
        if (state is! UserHistoryReady) {
          emit(UserHistoryState.error(error: failure.reason));
        }
        _snackShower.error(message: failure.reason);
      });
  }
}
