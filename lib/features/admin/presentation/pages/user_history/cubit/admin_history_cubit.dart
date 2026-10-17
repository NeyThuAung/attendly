import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:attendly/core/services/snack_shower.dart';
import 'package:attendly/features/admin/domain/usecases/get_all_user_history_use_case.dart';
import 'package:attendly/features/admin/domain/usecases/get_users_list_use_case.dart';

import '../../../../../attendance/domain/entity/attendance_entity.dart';
import '../../../../../auth/domain/entity/user_entity.dart';

part 'admin_history_state.dart';
part 'admin_history_cubit.freezed.dart';

@injectable
class AdminHistoryCubit extends Cubit<AdminHistoryState> {
  final GetAllUserHistoryUseCase _getAllUserHistoryUseCase;
  final GetUsersListUseCase _getUsersListUseCase;
  final ISnackShower _snackShower;

  AdminHistoryCubit(
    this._getAllUserHistoryUseCase,
    this._getUsersListUseCase,
    this._snackShower,
  ) : super(const AdminHistoryState.initial()) {
    init();
  }

  Future<void> init({bool forceReload = false}) async {
    final currentState = state;
    if (!forceReload && currentState is AdminHistoryInitial && currentState.logs.isNotEmpty) {
      return;
    }

    await loadUsers();
    await filterLogs(forceReload: forceReload);
  }

  Future<void> loadUsers() async {
    final result = await _getUsersListUseCase.call(
      const UsersListParam(limit: 100),
    );

    result.onSuccess((users) {
      if (isClosed) return;

      state.maybeMap(
        initial: (currentState) {
          emit(currentState.copyWith(users: users));
        },
        orElse: () {},
      );
    });
  }

  Future<void> filterLogs({
    String? userId,
    DateTime? date,
    bool clearUserFilter = false,
    bool clearDateFilter = false,
    bool forceReload = false,
  }) async {
    final currentState = state;

    final selectedUserId = clearUserFilter
        ? null
        : (userId != null ? (userId.isEmpty ? null : userId) : currentState.selectedUserId);

    final selectedDate = clearDateFilter
        ? null
        : (date ?? currentState.selectedDate);

    if (!forceReload &&
        currentState.logs.isNotEmpty &&
        selectedUserId == currentState.selectedUserId &&
        selectedDate == currentState.selectedDate) {
      return;
    }

    emit(
      currentState.copyWith(
        isLoading: true,
        selectedUserId: selectedUserId,
        selectedDate: selectedDate,
      ),
    );

    final result = await _getAllUserHistoryUseCase.call(
      AdminHistoryParam(
        userId: selectedUserId,
        date: selectedDate,
      ),
    );

    if (isClosed) return;

    result
      ..onSuccess((logs) {
        state.maybeMap(
          initial: (currentState) {
            emit(
              currentState.copyWith(
                isLoading: false,
                logs: logs,
              ),
            );
          },
          orElse: () {},
        );
      })
      ..onError((failure) {
        state.maybeMap(
          initial: (currentState) {
            emit(currentState.copyWith(isLoading: false));
          },
          orElse: () {},
        );
        _snackShower.error(message: failure.reason);
      });
  }

  Future<void> clearFilters() async {
    emit(
      state.copyWith(
        isLoading: true,
        selectedUserId: null,
        selectedDate: null,
      ),
    );

    final result = await _getAllUserHistoryUseCase.call(
      const AdminHistoryParam(
        userId: null,
        date: null,
      ),
    );

    if (isClosed) return;

    result
      ..onSuccess((logs) {
        state.maybeMap(
          initial: (currentState) {
            emit(
              currentState.copyWith(
                isLoading: false,
                logs: logs,
              ),
            );
          },
          orElse: () {},
        );
      })
      ..onError((failure) {
        state.maybeMap(
          initial: (currentState) {
            emit(currentState.copyWith(isLoading: false));
          },
          orElse: () {},
        );
        _snackShower.error(message: failure.reason);
      });
  }
}
