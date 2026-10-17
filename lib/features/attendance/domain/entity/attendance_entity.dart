enum AttendanceType {
  checkIn,
  checkOut,
}

class AttendanceEntity {
  final String id;
  final String userId;
  final AttendanceType type;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String address;
  final bool isSynced;

  const AttendanceEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isSynced,
  });
}
