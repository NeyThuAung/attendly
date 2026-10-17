part of 'users_list_cubit.dart';

@freezed
abstract class UsersListState with _$UsersListState {
  const factory UsersListState.initial({
    @Default(true) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
    @Default(<UserEntity>[]) List<UserEntity> users,
    String? searchQuery,
  }) = UsersListInitial;
}
