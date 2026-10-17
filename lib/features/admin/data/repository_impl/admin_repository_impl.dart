import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../attendance/domain/entity/attendance_entity.dart';
import '../../domain/entity/dashboard_summary_entity.dart';
import '../../domain/repository/admin_repository.dart';
import '../data_source/admin_remote_data_source.dart';

@LazySingleton(as: AdminRepository)
class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  const AdminRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<DashboardSummaryEntity>> getDashboardSummary() async {
    try {
      final summary = await _remoteDataSource.getDashboardSummary();
      return Success(summary);
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }

  @override
  Future<DataState<List<UserEntity>>> getUsersList(
      {String? searchQuery, int limit = 20}) async {
    try {
      final models = await _remoteDataSource.getUsersList(
          searchQuery: searchQuery, limit: limit);
      return Success(models.map((m) => m.toEntity()).toList());
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }

  @override
  Future<DataState<List<AttendanceEntity>>> getAllUserHistory(
      {String? userId, DateTime? date}) async {
    try {
      final models =
          await _remoteDataSource.getAllUserHistory(userId: userId, date: date);
      return Success(models.map((m) => m.toEntity()).toList());
    } on FirebaseException catch (e) {
      final remoteEx = e.toRemoteException();
      return Failed(remoteEx.toFailure());
    } catch (e) {
      return Failed(UnknownNetworkFailure(e.toString()));
    }
  }
}
