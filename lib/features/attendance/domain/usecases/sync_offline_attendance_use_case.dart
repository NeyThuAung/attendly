import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../repository/attendance_repository.dart';

@lazySingleton
class SyncOfflineAttendanceUseCase implements UseCase<DataState<void>, void> {
  final AttendanceRepository _repository;
  const SyncOfflineAttendanceUseCase(this._repository);

  @override
  Future<DataState<void>> call(void param) {
    return _repository.syncOfflineLogs();
  }
}
