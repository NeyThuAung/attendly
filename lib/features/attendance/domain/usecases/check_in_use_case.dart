import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../entity/attendance_entity.dart';
import '../entity/location_entity.dart';
import '../repository/attendance_repository.dart';

class CheckInParam {
  final String userId;
  final GeoLocationEntity location;
  const CheckInParam({required this.userId, required this.location});
}

@lazySingleton
class CheckInUseCase implements UseCase<DataState<AttendanceEntity>, CheckInParam> {
  final AttendanceRepository _repository;
  const CheckInUseCase(this._repository);

  @override
  Future<DataState<AttendanceEntity>> call(CheckInParam param) {
    return _repository.checkIn(userId: param.userId, location: param.location);
  }
}
