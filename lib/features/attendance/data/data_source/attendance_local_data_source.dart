import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:attendly/core/database/app_database.dart';
import '../model/attendance_model.dart';

abstract interface class AttendanceLocalDataSource {
  Future<void> saveOfflineLog(AttendanceModel model);
  Future<List<AttendanceModel>> getUnsyncedLogs();
  Future<void> markAsSynced(String id);
}

@LazySingleton(as: AttendanceLocalDataSource)
class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  final AppDatabase _database;
  const AttendanceLocalDataSourceImpl(this._database);

  @override
  Future<void> saveOfflineLog(AttendanceModel model) async {
    await _database.insertOfflineLog(
      OfflineAttendanceLogsCompanion(
        id: Value(model.id),
        userId: Value(model.userId),
        type: Value(model.type),
        timestamp: Value(DateTime.fromMillisecondsSinceEpoch(model.timestampMillis)),
        latitude: Value(model.latitude),
        longitude: Value(model.longitude),
        address: Value(model.address),
        isSynced: Value(model.isSynced),
      ),
    );
  }

  @override
  Future<List<AttendanceModel>> getUnsyncedLogs() async {
    final rows = await _database.getUnsyncedLogs();
    return rows.map((row) => AttendanceModel(
      id: row.id,
      userId: row.userId,
      type: row.type,
      timestampMillis: row.timestamp.millisecondsSinceEpoch,
      latitude: row.latitude,
      longitude: row.longitude,
      address: row.address ?? '',
      isSynced: row.isSynced,
    )).toList();
  }

  @override
  Future<void> markAsSynced(String id) async {
    await _database.markLogAsSynced(id);
  }
}
