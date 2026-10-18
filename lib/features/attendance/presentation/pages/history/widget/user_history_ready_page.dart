import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attendly/features/attendance/domain/entity/attendance_entity.dart';
import 'package:attendly/shared/components/prompt/offline_sync_banner.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';
import '../cubit/user_history_cubit.dart';

class UserHistoryReadyPage extends StatefulWidget {
  final List<AttendanceEntity> logs;
  final List<AttendanceEntity> syncedLogs;
  final List<AttendanceEntity> unsyncedLogs;
  final bool isOffline;
  final int unsyncedCount;

  const UserHistoryReadyPage({
    super.key,
    required this.logs,
    this.syncedLogs = const [],
    this.unsyncedLogs = const [],
    this.isOffline = false,
    this.unsyncedCount = 0,
  });

  @override
  State<UserHistoryReadyPage> createState() => _UserHistoryReadyPageState();
}

class _UserHistoryReadyPageState extends State<UserHistoryReadyPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildLogList(
      List<AttendanceEntity> logs, bool isDark, Color cardBorderColor) {
    if (logs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No records found.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: $styles.color.clrDarkGrey,
            ),
          ),
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          refreshTriggerPullDistance: 100,
          refreshIndicatorExtent: 60,
          onRefresh: () async => context.read<UserHistoryCubit>().loadHistory(showLoading: false),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            16,
            10,
            16,
            context.bottomPadding + 15,
          ),
          sliver: SliverList.separated(
            itemCount: logs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final log = logs[index];

              final isCheckIn = log.type == AttendanceType.checkIn;
              final titleText = isCheckIn ? 'Check in' : 'Check out';
              final badgeText = isCheckIn ? 'IN' : 'OUT';
              final badgeBgColor = isCheckIn
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.12);
              final badgeTextColor = isCheckIn
                  ? (isDark ? Colors.green.shade400 : Colors.green.shade700)
                  : (isDark ? Colors.red.shade300 : Colors.red.shade700);

              final dateFormatted = DateFormat('EEE, d MMM').format(log.timestamp);
              final timeFormatted = DateFormat('hh:mm a').format(log.timestamp);
              final dateTimeString = '$dateFormatted · $timeFormatted';

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: cardBorderColor, width: 1),
                ),
                color: isDark ? context.theme.cardColor : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top Row: Check in / Check out Title & IN/OUT Pill Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            titleText,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              borderRadius: BorderRadius.circular(8),
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

                      /// Second Row: Date · Time (e.g. Thu, 15 Oct · 05:30 PM)
                      Text(
                        dateTimeString,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 2),

                      /// Third Row: Location (e.g. Hlaing, Yangon)
                      Text(
                        log.address.isNotEmpty == true
                            ? log.address
                            : 'Location recorded',
                        style: context.textTheme.bodySmall?.copyWith(
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : $styles.color.clrSoftGrey;

    final syncedLogs = widget.syncedLogs.isEmpty && widget.logs.isNotEmpty
        ? widget.logs.where((l) => l.isSynced).toList()
        : widget.syncedLogs;

    final unsyncedLogs = widget.unsyncedLogs.isEmpty && widget.logs.isNotEmpty
        ? widget.logs.where((l) => !l.isSynced).toList()
        : widget.unsyncedLogs;

    final displaySynced =
        syncedLogs.isEmpty && unsyncedLogs.isEmpty ? widget.logs : syncedLogs;

    return Column(
      children: [
        /// Offline Banner if pending sync records exist
        if (widget.isOffline || widget.unsyncedCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OfflineSyncBanner(
              unsyncedCount: widget.unsyncedCount,
              isOffline: widget.isOffline,
            ),
          ),

        /// TabBar: Synced vs Pending
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: context.theme.primaryColor,
            indicatorWeight: 2,
            labelColor: context.theme.primaryColor,
            unselectedLabelColor: $styles.color.clrDarkGrey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: [
              const Tab(text: 'Synced'),
              Tab(text: 'Pending (${widget.unsyncedCount})'),
            ],
          ),
        ),

        /// Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLogList(displaySynced, isDark, cardBorderColor),
              _buildLogList(unsyncedLogs, isDark, cardBorderColor),
            ],
          ),
        ),
      ],
    );
  }
}
