import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';
import '../cubit/home_page_cubit.dart';

class StatusCardSection extends StatelessWidget {
  const StatusCardSection({super.key, required this.state});

  final HomeState state;

  String _formatTodayDate() {
    return DateFormat('EEEE, d MMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = state is HomeInitial && state.isCheckedIn;
    final checkInTime = state is HomeInitial ? state.checkInTime : null;
    final lastLog = state is HomeInitial ? state.lastLog : null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : $styles.color.clrSoftGrey;

    final String statusText;
    final Color badgeColor;
    final Color badgeTextColor;

    if (isCheckedIn) {
      statusText = 'Checked in';
      badgeColor = const Color(0xFF0C381E);
      badgeTextColor = const Color(0xFF4CAF50);
    } else if (lastLog != null) {
      statusText = 'Checked out';
      badgeColor = const Color(0xFF38230C);
      badgeTextColor = const Color(0xFFFF9800);
    } else {
      statusText = 'Not checked in';
      badgeColor = Colors.grey.shade900;
      badgeTextColor = Colors.grey.shade400;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cardBorderColor, width: 1),
      ),
      color: isDark ? context.theme.cardColor : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row: Status text on left, Badge on right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: $styles.color.clrDarkGrey,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: badgeTextColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Large Current Date Display
            Text(
              _formatTodayDate(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: context.textTheme.titleMedium?.color,
              ),
            ),

            const SizedBox(height: 4),

            /// Subtitle: Check-in time / status info
            if (isCheckedIn && checkInTime != null)
              Text(
                'Checked in at ${DateFormat('hh:mm a').format(checkInTime)}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              )
            else if (lastLog != null)
              Text(
                'Last action at ${DateFormat('hh:mm a').format(lastLog.timestamp)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: $styles.color.clrDarkGrey,
                  fontSize: 13,
                ),
              )
            else
              Text(
                'Ready to check in today',
                style: context.textTheme.bodySmall?.copyWith(
                  color: $styles.color.clrDarkGrey,
                  fontSize: 13,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
