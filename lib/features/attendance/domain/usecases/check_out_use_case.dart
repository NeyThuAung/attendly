import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../entity/attendance_entity.dart';
import '../entity/location_entity.dart';
import '../repository/attendance_repository.dart';

class CheckOutParam {
  final String userId;
  final GeoLocationEntity location;
  const CheckOutParam({required this.userId, required this.location});
}

@lazySingleton
class CheckOutUseCase implements UseCase<DataState<AttendanceEntity>, CheckOutParam> {
  final AttendanceRepository _repository;
  const CheckOutUseCase(this._repository);

  @override
  Future<DataState<AttendanceEntity>> call(CheckOutParam param) {
    return _repository.checkOut(userId: param.userId, location: param.location);
  }
}
