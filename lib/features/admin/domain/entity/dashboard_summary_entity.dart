class DashboardSummaryEntity {
  final int totalUsers;
  final int todayCheckIns;
  final int todayCheckOuts;

  const DashboardSummaryEntity({
    required this.totalUsers,
    required this.todayCheckIns,
    required this.todayCheckOuts,
  });
}
