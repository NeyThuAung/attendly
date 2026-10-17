part of 'admin_history_cubit.dart';

@freezed
abstract class AdminHistoryState with _$AdminHistoryState {
  const factory AdminHistoryState.initial({
    @Default(true) bool isLoading,
    @Default(<AttendanceEntity>[]) List<AttendanceEntity> logs,
    @Default(<UserEntity>[]) List<UserEntity> users,
    String? selectedUserId,
    DateTime? selectedDate,
  }) = AdminHistoryInitial;
}
