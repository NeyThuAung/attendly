import 'package:injectable/injectable.dart';
import 'package:attendly/core/core.dart';
import '../entity/attendance_entity.dart';
import '../repository/attendance_repository.dart';

@lazySingleton
class GetLastAttendanceLogUseCase implements UseCase<DataState<AttendanceEntity?>, String> {
  final AttendanceRepository _repository;
  const GetLastAttendanceLogUseCase(this._repository);

  @override
  Future<DataState<AttendanceEntity?>> call(String userId) {
    return _repository.getLastAttendanceLog(userId);
  }
}
