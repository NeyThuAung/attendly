import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/firestore_config.dart';
import '../../../auth/data/model/user_model.dart';
import '../../../attendance/data/model/attendance_model.dart';
import '../../domain/entity/dashboard_summary_entity.dart';

abstract interface class AdminRemoteDataSource {
  Future<DashboardSummaryEntity> getDashboardSummary();

  Future<List<UserModel>> getUsersList({String? searchQuery, int limit = 15});

  Future<List<AttendanceModel>> getAllUserHistory(
      {String? userId, DateTime? date});
}

@LazySingleton(as: AdminRemoteDataSource)
class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final FirebaseFirestore _firestore;

  const AdminRemoteDataSourceImpl(this._firestore);

  @override
  Future<DashboardSummaryEntity> getDashboardSummary() async {
    final usersSnap = await _firestore.collection(FirestoreConfig.users).get();

    // Count only employee/user accounts (excluding admin accounts)
    final totalEmployees = usersSnap.docs.where((doc) {
      final role = (doc.data()['role'] as String?)?.toLowerCase();
      return role != 'admin';
    }).length;

    final now = DateTime.now();
    final startOfDay =
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

    final logsSnap = await _firestore
        .collection(FirestoreConfig.attendanceLogs)
        .where('timestampMillis', isGreaterThanOrEqualTo: startOfDay)
        .get();

    int checkIns = 0;
    int checkOuts = 0;

    for (final doc in logsSnap.docs) {
      final type = doc.data()['type'] as String?;
      if (type == 'check_in') checkIns++;
      if (type == 'check_out') checkOuts++;
    }

    return DashboardSummaryEntity(
      totalUsers: totalEmployees,
      todayCheckIns: checkIns,
      todayCheckOuts: checkOuts,
    );
  }

  @override
  Future<List<UserModel>> getUsersList(
      {String? searchQuery, int limit = 15}) async {
    Query query = _firestore.collection(FirestoreConfig.users);

    final snapshot = await query.get();

    var users = snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .where((u) => u.role.toLowerCase() != 'admin')
        .toList();

    if (searchQuery?.isNotEmpty == true) {
      final q = searchQuery!.toLowerCase();
      users = users
          .where((u) =>
              u.name.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q))
          .toList();
    }

    if (users.length > limit) {
      users = users.sublist(0, limit);
    }

    return users;
  }

  @override
  Future<List<AttendanceModel>> getAllUserHistory(
      {String? userId, DateTime? date}) async {
    Query query = _firestore.collection(FirestoreConfig.attendanceLogs);

    if (userId?.isNotEmpty == true) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (date != null) {
      final startOfDay =
          DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
      final endOfDay =
          DateTime(date.year, date.month, date.day, 23, 59, 59, 999)
              .millisecondsSinceEpoch;
      query = query.where('timestampMillis',
          isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay);
    }

    try {
      final snapshot = await query.get();
      final logs = snapshot.docs
          .map((doc) =>
              AttendanceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      logs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
      return logs;
    } catch (_) {
      // Fallback while composite index is building in Firebase Console
      Query fallbackQuery =
          _firestore.collection(FirestoreConfig.attendanceLogs);
      if (userId?.isNotEmpty == true) {
        fallbackQuery = fallbackQuery.where('userId', isEqualTo: userId);
      }
      final snapshot = await fallbackQuery.get();
      var logs = snapshot.docs
          .map((doc) =>
              AttendanceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (date != null) {
        final startOfDay =
            DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
        final endOfDay =
            DateTime(date.year, date.month, date.day, 23, 59, 59, 999)
                .millisecondsSinceEpoch;
        logs = logs
            .where((l) =>
                l.timestampMillis >= startOfDay &&
                l.timestampMillis <= endOfDay)
            .toList();
      }

      logs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
      return logs;
    }
  }
}
