part of 'user_history_cubit.dart';

@freezed
abstract class UserHistoryState with _$UserHistoryState {
  const factory UserHistoryState.initial() = UserHistoryInitial;
  const factory UserHistoryState.loading() = UserHistoryLoading;
  const factory UserHistoryState.ready({
    required List<AttendanceEntity> logs,
    @Default(<AttendanceEntity>[]) List<AttendanceEntity> syncedLogs,
    @Default(<AttendanceEntity>[]) List<AttendanceEntity> unsyncedLogs,
    @Default(false) bool isOffline,
    @Default(0) int unsyncedCount,
  }) = UserHistoryReady;
  const factory UserHistoryState.error({
    required String error,
  }) = UserHistoryError;
}
