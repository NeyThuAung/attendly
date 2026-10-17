import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attendly/di/injector.dart';
import 'package:attendly/features/attendance/domain/entity/attendance_entity.dart';
import 'package:attendly/features/auth/domain/entity/user_entity.dart';
import 'package:attendly/shared/components/loading/loading_body.dart';
import 'package:attendly/shared/components/wrapper/dismiss_focus_wrapper.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'cubit/admin_history_cubit.dart';

class AdminHistoryPage extends StatelessWidget {
  const AdminHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : $styles.color.clrSoftGrey;

    return DismissFocusWrapper(
      child: BlocProvider(
        create: (_) => inject<AdminHistoryCubit>(),
        child: BlocBuilder<AdminHistoryCubit, AdminHistoryState>(
          builder: (context, state) {
            final cubit = context.read<AdminHistoryCubit>();
            final isLoading = state is AdminHistoryInitial && state.isLoading;
            final logs = state is AdminHistoryInitial ? state.logs : <AttendanceEntity>[];
            final users = state is AdminHistoryInitial ? state.users : [];
            final selectedUserId = state is AdminHistoryInitial ? state.selectedUserId : null;
            final selectedDate = state is AdminHistoryInitial ? state.selectedDate : null;

            final hasActiveFilter = selectedUserId != null || selectedDate != null;

            return Scaffold(
              appBar: AppBar(
                title: const Text('All Attendance Logs'),
                actions: [
                  if (hasActiveFilter)
                    IconButton(
                      icon: const Icon(Icons.filter_alt_off_outlined, color: Colors.red),
                      onPressed: () => cubit.clearFilters(),
                      tooltip: 'Clear Filters',
                    ),
                ],
              ),
              body: Column(
                children: [
                  /// Filter Bar Section
                  Padding(
                    padding: EdgeInsets.all($styles.insets.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            /// User Filter Dropdown
                            Expanded(
                              child: DropdownButtonFormField<String?>(
                                key: ValueKey(selectedUserId),
                                initialValue: selectedUserId,
                                decoration: InputDecoration(
                                  labelText: 'Filter by User',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: [
                                  const DropdownMenuItem(
                                      value: null, child: Text('All Users')),
                                  ...users.map((u) => DropdownMenuItem(
                                      value: u.uid, child: Text(u.name))),
                                ],
                                onChanged: (uid) {
                                  if (uid == null) {
                                    cubit.filterLogs(
                                        userId: null, clearUserFilter: true);
                                  } else {
                                    cubit.filterLogs(userId: uid);
                                  }
                                },
                              ),
                            ),

                            const SizedBox(width: 8),

                            /// Date Picker Filter Button
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  cubit.filterLogs(date: picked);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedDate != null
                                        ? context.theme.primaryColor
                                        : Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: selectedDate != null
                                      ? context.theme.primaryColor
                                          .withValues(alpha: 0.1)
                                      : null,
                                ),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: selectedDate != null
                                      ? context.theme.primaryColor
                                      : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// Active Filter Badge Chip
                        if (selectedDate != null) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            children: [
                              Chip(
                                avatar: const Icon(Icons.calendar_today, size: 14),
                                label: Text(
                                  'Date: ${DateFormat('d MMM yyyy').format(selectedDate)}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                                onDeleted: () {
                                  cubit.filterLogs(clearDateFilter: true);
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  /// History Logs List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await cubit.init(forceReload: true);
                      },
                      child: isLoading && logs.isEmpty
                          ? const LoadingBody()
                          : logs.isEmpty
                              ? SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                    height: 300,
                                    alignment: Alignment.center,
                                    child: const Text('No attendance logs found.'),
                                  ),
                                )
                              : ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    $styles.insets.sm,
                                    0,
                                    $styles.insets.sm,
                                    context.bottomPadding + 15,
                                  ),
                                  itemCount: logs.length,
                                  itemBuilder: (context, index) {
                                    final log = logs[index];
                                    final isCheckIn =
                                        log.type == AttendanceType.checkIn;
                                    final titleText =
                                        isCheckIn ? 'Check in' : 'Check out';
                                    final badgeText = isCheckIn ? 'IN' : 'OUT';
                                    final badgeBgColor = isCheckIn
                                        ? Colors.green.withValues(alpha: 0.12)
                                        : Colors.red.withValues(alpha: 0.12);
                                    final badgeTextColor = isCheckIn
                                        ? (isDark
                                            ? Colors.green.shade400
                                            : Colors.green.shade700)
                                        : (isDark
                                            ? Colors.red.shade300
                                            : Colors.red.shade700);

                                    // Find user name from loaded users list
                                    final userObj = users.firstWhere(
                                      (u) => u.uid == log.userId,
                                      orElse: () => UserEntity(
                                        uid: log.userId,
                                        email: '',
                                        name: 'User (${log.userId.substring(0, log.userId.length > 6 ? 6 : log.userId.length)})',
                                        role: UserRole.user,
                                        createdAt: DateTime.now(),
                                      ),
                                    );

                                    final dateFormatted = DateFormat('EEE, d MMM')
                                        .format(log.timestamp);
                                    final timeFormatted = DateFormat('hh:mm a')
                                        .format(log.timestamp);
                                    final dateTimeString =
                                        '$dateFormatted · $timeFormatted';

                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                            color: cardBorderColor, width: 1),
                                      ),
                                      color: isDark
                                          ? context.theme.cardColor
                                          : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// Top Row: Employee Name & IN/OUT Pill Badge
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${userObj.name} · $titleText',
                                                    style: context
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: badgeBgColor,
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    badgeText,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                      color: badgeTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 4),

                                            /// Second Row: Date · Time
                                            Text(
                                              dateTimeString,
                                              style: context.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: context
                                                    .textTheme.bodyMedium?.color
                                                    ?.withValues(alpha: 0.9),
                                                fontSize: 13,
                                              ),
                                            ),

                                          const SizedBox(height: 2),

                                          /// Third Row: Location Address
                                          Text(
                                            log.address.isNotEmpty == true
                                                ? log.address
                                                : 'Location recorded',
                                            style: context.textTheme.bodySmall
                                                ?.copyWith(
                                              color: $styles.color.clrDarkGrey,
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
