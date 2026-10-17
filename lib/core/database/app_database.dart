import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

part 'app_database.g.dart';

class OfflineAttendanceLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()(); // 'check_in' or 'check_out'
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@LazySingleton()
@DriftDatabase(tables: [OfflineAttendanceLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'attendly_offline_db');
  }

  // Insert or replace offline log
  Future<int> insertOfflineLog(OfflineAttendanceLogsCompanion log) =>
      into(offlineAttendanceLogs).insert(log, mode: InsertMode.insertOrReplace);

  // Get un-synced logs
  Future<List<OfflineAttendanceLog>> getUnsyncedLogs() =>
      (select(offlineAttendanceLogs)..where((tbl) => tbl.isSynced.equals(false))).get();

  // Mark log as synced
  Future<int> markLogAsSynced(String id) =>
      (update(offlineAttendanceLogs)..where((tbl) => tbl.id.equals(id)))
          .write(const OfflineAttendanceLogsCompanion(isSynced: Value(true)));

  // Delete synced logs
  Future<int> clearSyncedLogs() =>
      (delete(offlineAttendanceLogs)..where((tbl) => tbl.isSynced.equals(true))).go();
}
