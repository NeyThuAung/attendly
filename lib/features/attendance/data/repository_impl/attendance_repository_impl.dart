import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../domain/entity/attendance_entity.dart';
import '../../domain/entity/location_entity.dart';
import '../../domain/repository/attendance_repository.dart';
import '../data_source/attendance_local_data_source.dart';
import '../data_source/attendance_remote_data_source.dart';
import '../model/attendance_model.dart';

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource _remoteDataSource;
  final AttendanceLocalDataSource _localDataSource;

  const AttendanceRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<DataState<AttendanceEntity>> checkIn({
    required String userId,
    required GeoLocationEntity location,
  }) async {
    return _recordLog(
      userId: userId,
      type: AttendanceType.checkIn,
      location: location,
    );
  }

  @override
  Future<DataState<AttendanceEntity>> checkOut({
    required String userId,
    required GeoLocationEntity location,
  }) async {
    return _recordLog(
      userId: userId,
      type: AttendanceType.checkOut,
      location: location,
    );
  }

  Future<DataState<AttendanceEntity>> _recordLog({
    required String userId,
    required AttendanceType type,
    required GeoLocationEntity location,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final model = AttendanceModel(
        id: id,
        userId: userId,
        type: type == AttendanceType.checkIn ? 'check_in' : 'check_out',
        timestampMillis: DateTime.now().millisecondsSinceEpoch,
        latitude: location.latitude,
        longitude: location.longitude,
        address: location.address,
        isSynced: false,
      );

      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = !connectivityResult.contains(ConnectivityResult.none);

      if (isOnline) {
        await _remoteDataSource
            .recordAttendance(model.copyWith(isSynced: true));
        return Success(model.copyWith(isSynced: true).toEntity());
      } else {
        await _localDataSource.saveOfflineLog(model);
        return Success(model.toEntity());
      }
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<DataState<List<AttendanceEntity>>> getUserHistory(
      String userId) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = !connectivityResult.contains(ConnectivityResult.none);

      if (isOnline) {
        await syncOfflineLogs();
        final remoteModels = await _remoteDataSource.getUserHistory(userId);
        return Success(remoteModels.map((m) => m.toEntity()).toList());
      } else {
        final localModels = await _localDataSource.getUnsyncedLogs();
        final userLogs = localModels.where((m) => m.userId == userId).toList();
        userLogs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
        return Success(userLogs.map((m) => m.toEntity()).toList());
      }
    } on FirebaseException {
      final localModels = await _localDataSource.getUnsyncedLogs();
      final userLogs = localModels.where((m) => m.userId == userId).toList();
      userLogs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
      return Success(userLogs.map((m) => m.toEntity()).toList());
    } catch (e) {
      final localModels = await _localDataSource.getUnsyncedLogs();
      final userLogs = localModels.where((m) => m.userId == userId).toList();
      userLogs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
      return Success(userLogs.map((m) => m.toEntity()).toList());
    }
  }

  @override
  Future<DataState<void>> syncOfflineLogs() async {
    try {
      final unsynced = await _localDataSource.getUnsyncedLogs();
      if (unsynced.isEmpty) return const Success(null);

      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = !connectivityResult.contains(ConnectivityResult.none);
      if (!isOnline) return const Success(null);

      for (final log in unsynced) {
        await _remoteDataSource.recordAttendance(log.copyWith(isSynced: true));
        await _localDataSource.markAsSynced(log.id);
      }
      return const Success(null);
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }

  @override
  Future<DataState<AttendanceEntity?>> getLastAttendanceLog(
      String userId) async {
    try {
      final List<AttendanceModel> allLogs = [];

      final localModels = await _localDataSource.getUnsyncedLogs();
      final userLocalLogs =
          localModels.where((m) => m.userId == userId).toList();
      allLogs.addAll(userLocalLogs);

      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = !connectivityResult.contains(ConnectivityResult.none);

      if (isOnline) {
        try {
          final remoteModels = await _remoteDataSource.getUserHistory(userId);
          allLogs.addAll(remoteModels);
        } catch (_) {}
      }

      if (allLogs.isEmpty) return const Success(null);

      final Map<String, AttendanceModel> uniqueLogs = {};
      for (final log in allLogs) {
        uniqueLogs[log.id] = log;
      }

      final sortedLogs = uniqueLogs.values.toList();
      sortedLogs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));

      return Success(sortedLogs.first.toEntity());
    } catch (e) {
      final localModels = await _localDataSource.getUnsyncedLogs();
      final userLogs = localModels.where((m) => m.userId == userId).toList();
      userLogs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
      return Success(userLogs.isNotEmpty ? userLogs.first.toEntity() : null);
    }
  }

  @override
  Future<DataState<int>> getUnsyncedCount() async {
    try {
      final unsynced = await _localDataSource.getUnsyncedLogs();
      return Success(unsynced.length);
    } catch (e) {
      return const Success(0);
    }
  }
}
