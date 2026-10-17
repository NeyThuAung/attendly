import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/firestore_config.dart';
import '../model/attendance_model.dart';

abstract interface class AttendanceRemoteDataSource {
  Future<void> recordAttendance(AttendanceModel model);

  Future<List<AttendanceModel>> getUserHistory(String userId);

  Future<AttendanceModel?> getLastAttendanceLog(String userId);
}

@LazySingleton(as: AttendanceRemoteDataSource)
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final FirebaseFirestore _firestore;

  const AttendanceRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> recordAttendance(AttendanceModel model) async {
    await _firestore
        .collection(FirestoreConfig.attendanceLogs)
        .doc(model.id)
        .set(model.toJson());
  }

  @override
  Future<List<AttendanceModel>> getUserHistory(String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreConfig.attendanceLogs)
        .where('userId', isEqualTo: userId)
        .get();

    final logs = snapshot.docs
        .map((doc) => AttendanceModel.fromJson(doc.data()))
        .toList();

    logs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
    return logs;
  }

  @override
  Future<AttendanceModel?> getLastAttendanceLog(String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreConfig.attendanceLogs)
        .where('userId', isEqualTo: userId)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final logs = snapshot.docs
        .map((doc) => AttendanceModel.fromJson(doc.data()))
        .toList();

    logs.sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
    return logs.first;
  }
}
