import '../../../../core/core.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../attendance/domain/entity/attendance_entity.dart';
import '../entity/dashboard_summary_entity.dart';

abstract interface class AdminRepository {
  Future<DataState<DashboardSummaryEntity>> getDashboardSummary();

  Future<DataState<List<UserEntity>>> getUsersList(
      {String? searchQuery, int limit = 20});

  Future<DataState<List<AttendanceEntity>>> getAllUserHistory(
      {String? userId, DateTime? date});
}
