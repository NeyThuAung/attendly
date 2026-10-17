import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:attendly/core/services/snack_shower.dart';
import 'package:attendly/features/admin/domain/usecases/get_users_list_use_case.dart';
import 'package:attendly/features/auth/domain/entity/user_entity.dart';

part 'users_list_cubit.freezed.dart';
part 'users_list_state.dart';

@injectable
class UsersListCubit extends Cubit<UsersListState> {
  final GetUsersListUseCase _getUsersListUseCase;
  final ISnackShower _snackShower;

  static const int _pageSize = 15;
  int _currentLimit = _pageSize;

  UsersListCubit(
    this._getUsersListUseCase,
    this._snackShower,
  ) : super(const UsersListState.initial()) {
    searchUsers();
  }

  Future<void> searchUsers({String? query, bool forceReload = false}) async {
    // If already in success state with data and not forcing reload, keep existing state
    if (!forceReload && state.users.isNotEmpty && (query == null || query == state.searchQuery)) {
      return;
    }

    _currentLimit = _pageSize;
    emit(state.copyWith(
      isLoading: true,
      hasReachedMax: false,
      searchQuery: query,
    ));

    final res = await _getUsersListUseCase.call(
      UsersListParam(searchQuery: query, limit: _currentLimit),
    );

    if (isClosed) return;

    res
      ..onSuccess((users) {
        emit(state.copyWith(
          isLoading: false,
          users: users,
          hasReachedMax: users.length < _currentLimit,
        ));
      })
      ..onError((failure) {
        emit(state.copyWith(isLoading: false));
        _snackShower.error(message: failure.reason);
      });
  }

  Future<void> loadMoreUsers() async {
    if (state.isLoading || state.isLoadingMore || state.hasReachedMax) return;

    emit(state.copyWith(isLoadingMore: true));

    _currentLimit += _pageSize;

    final res = await _getUsersListUseCase.call(
      UsersListParam(searchQuery: state.searchQuery, limit: _currentLimit),
    );

    if (isClosed) return;

    res
      ..onSuccess((users) {
        final isMax = users.length == state.users.length || users.length < _currentLimit;
        emit(state.copyWith(
          isLoadingMore: false,
          users: users,
          hasReachedMax: isMax,
        ));
      })
      ..onError((failure) {
        emit(state.copyWith(isLoadingMore: false));
        _snackShower.error(message: failure.reason);
      });
  }
}
