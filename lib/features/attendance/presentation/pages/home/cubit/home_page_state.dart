part of 'home_page_cubit.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial({
    @Default(false) bool isLoading,
    @Default(false) bool isCheckedIn,
    @Default(0) int elapsedSeconds,
    @Default(0) int unsyncedCount,
    @Default(false) bool isOffline,
    @Default(false) bool isGpsDisabled,
    @Default(false) bool isPermissionDenied,
    DateTime? checkInTime,
    GeoLocationEntity? currentLocation,
    AttendanceEntity? lastLog,
  }) = HomeInitial;
}
