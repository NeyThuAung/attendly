import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../../../attendance/domain/entity/attendance_entity.dart';
import '../repository/admin_repository.dart';

class AdminHistoryParam {
  final String? userId;
  final DateTime? date;

  const AdminHistoryParam({this.userId, this.date});
}

@lazySingleton
class GetAllUserHistoryUseCase
    implements UseCase<DataState<List<AttendanceEntity>>, AdminHistoryParam> {
  final AdminRepository _repository;

  const GetAllUserHistoryUseCase(this._repository);

  @override
  Future<DataState<List<AttendanceEntity>>> call(AdminHistoryParam param) {
    return _repository.getAllUserHistory(
        userId: param.userId, date: param.date);
  }
}
