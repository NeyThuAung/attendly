// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      timestampMillis: (json['timestampMillis'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      isSynced: json['isSynced'] as bool? ?? true,
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'timestampMillis': instance.timestampMillis,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'isSynced': instance.isSynced,
    };
