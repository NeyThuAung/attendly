import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:attendly/features/attendance/domain/entity/attendance_entity.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
abstract class AttendanceModel with _$AttendanceModel {
  const AttendanceModel._();

  const factory AttendanceModel({
    required String id,
    required String userId,
    required String type,
    required int timestampMillis,
    required double latitude,
    required double longitude,
    required String address,
    @Default(true) bool isSynced,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => _$AttendanceModelFromJson(json);

  factory AttendanceModel.fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type == AttendanceType.checkIn ? 'check_in' : 'check_out',
      timestampMillis: entity.timestamp.millisecondsSinceEpoch,
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      isSynced: entity.isSynced,
    );
  }

  AttendanceEntity toEntity() {
    return AttendanceEntity(
      id: id,
      userId: userId,
      type: type == 'check_in' ? AttendanceType.checkIn : AttendanceType.checkOut,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMillis),
      latitude: latitude,
      longitude: longitude,
      address: address,
      isSynced: isSynced,
    );
  }
}
