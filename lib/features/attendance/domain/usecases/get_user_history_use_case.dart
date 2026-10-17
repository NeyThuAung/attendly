import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../entity/attendance_entity.dart';
import '../repository/attendance_repository.dart';

@lazySingleton
class GetUserHistoryUseCase implements UseCase<DataState<List<AttendanceEntity>>, String> {
  final AttendanceRepository _repository;
  const GetUserHistoryUseCase(this._repository);

  @override
  Future<DataState<List<AttendanceEntity>>> call(String userId) {
    return _repository.getUserHistory(userId);
  }
}
