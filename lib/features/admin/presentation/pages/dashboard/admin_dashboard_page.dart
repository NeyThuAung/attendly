import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attendly/di/injector.dart';
import 'package:attendly/shared/components/loading/loading_body.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'cubit/admin_dashboard_cubit.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => inject<AdminDashboardCubit>(),
      child: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
        builder: (context, state) {
          final cubit = context.read<AdminDashboardCubit>();
          final isLoading = state is AdminDashboardInitial && state.isLoading;
          final summary = state is AdminDashboardInitial ? state.summary : null;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin Dashboard'),
            ),
            body: RefreshIndicator(
              onRefresh: () => cubit.loadSummary(forceReload: true),
              child: isLoading && summary == null
                  ? const LoadingBody()
                  : ListView(
                      padding: EdgeInsets.fromLTRB(
                        $styles.insets.sm,
                        $styles.insets.sm,
                        $styles.insets.sm,
                        context.bottomPadding + 15,
                      ),
                      children: [
                        _StatCard(
                          title: 'Total Employees',
                          count: '${summary?.totalUsers ?? 0}',
                          icon: Icons.people,
                          color: Colors.blue,
                        ),
                        8.heightBox,
                        _StatCard(
                          title: "Today's Check-Ins",
                          count: '${summary?.todayCheckIns ?? 0}',
                          icon: Icons.login,
                          color: Colors.green,
                        ),
                        8.heightBox,
                        _StatCard(
                          title: "Today's Check-Outs",
                          count: '${summary?.todayCheckOuts ?? 0}',
                          icon: Icons.logout,
                          color: Colors.red,
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : $styles.color.clrSoftGrey;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cardBorderColor, width: 1),
      ),
      color: isDark ? context.theme.cardColor : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
