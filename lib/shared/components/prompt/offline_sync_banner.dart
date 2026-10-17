import 'package:flutter/material.dart';

class OfflineSyncBanner extends StatelessWidget {
  final int unsyncedCount;
  final bool isOffline;

  const OfflineSyncBanner({
    super.key,
    required this.unsyncedCount,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline && unsyncedCount == 0) {
      return const SizedBox.shrink();
    }

    final String text = unsyncedCount > 0
        ? 'Offline · $unsyncedCount ${unsyncedCount == 1 ? "record" : "records"} pending sync'
        : 'Offline Mode';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2700).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFB300).withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 18,
            color: Color(0xFFFFB300),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
