import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:attendly/core/services/snack_shower.dart';
import 'package:attendly/features/admin/domain/usecases/get_dashboard_summary_use_case.dart';
import 'package:attendly/features/admin/domain/entity/dashboard_summary_entity.dart';

part 'admin_dashboard_cubit.freezed.dart';
part 'admin_dashboard_state.dart';

@injectable
class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final GetDashboardSummaryUseCase _getSummaryUseCase;
  final ISnackShower _snackShower;

  AdminDashboardCubit(
    this._getSummaryUseCase,
    this._snackShower,
  ) : super(const AdminDashboardState.initial()) {
    loadSummary();
  }

  Future<void> loadSummary({bool forceReload = false}) async {
    // If summary is already loaded and not forcing reload, preserve success state
    final currentState = state;
    if (!forceReload && currentState is AdminDashboardInitial && currentState.summary != null) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    final result = await _getSummaryUseCase.call(null);

    if (isClosed) return;

    result
      ..onSuccess((summary) {
        emit(
          state.copyWith(
            isLoading: false,
            summary: summary,
          ),
        );
      })
      ..onError((failure) {
        emit(state.copyWith(isLoading: false));
        _snackShower.error(message: failure.reason);
      });
  }
}
