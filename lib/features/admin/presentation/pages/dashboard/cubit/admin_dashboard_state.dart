part of 'admin_dashboard_cubit.dart';

@freezed
abstract class AdminDashboardState with _$AdminDashboardState {
  const factory AdminDashboardState.initial({
    @Default(true) bool isLoading,
    DashboardSummaryEntity? summary,
  }) = AdminDashboardInitial;
}
