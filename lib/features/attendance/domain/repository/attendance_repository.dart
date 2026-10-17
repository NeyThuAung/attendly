import '../../../../core/core.dart';
import '../entity/attendance_entity.dart';
import '../entity/location_entity.dart';

abstract interface class AttendanceRepository {
  Future<DataState<AttendanceEntity>> checkIn(
      {required String userId, required GeoLocationEntity location});

  Future<DataState<AttendanceEntity>> checkOut(
      {required String userId, required GeoLocationEntity location});

  Future<DataState<List<AttendanceEntity>>> getUserHistory(String userId);

  Future<DataState<void>> syncOfflineLogs();

  Future<DataState<AttendanceEntity?>> getLastAttendanceLog(String userId);

  Future<DataState<int>> getUnsyncedCount();
}
