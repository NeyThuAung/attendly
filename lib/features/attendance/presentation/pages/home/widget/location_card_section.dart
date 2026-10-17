import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';
import '../cubit/home_page_cubit.dart';

class LocationCardSection extends StatelessWidget {
  const LocationCardSection({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    final isGpsDisabled = state is HomeInitial && state.isGpsDisabled;
    final isPermissionDenied = state is HomeInitial && state.isPermissionDenied;
    final location = state is HomeInitial ? state.currentLocation : null;
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row: Current location & Refresh Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current location',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: $styles.color.clrDarkGrey,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () => cubit.fetchLocationAndStatus(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(Icons.refresh, size: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Warning Banner if GPS or Permission disabled
            if (isGpsDisabled || isPermissionDenied) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade700, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isGpsDisabled
                            ? 'Device GPS is turned off.'
                            : 'Location permission required.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        if (isGpsDisabled) {
                          cubit.openLocationSettings();
                        } else {
                          cubit.openAppSettings();
                        }
                      },
                      child: const Text('Open Settings', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            /// OpenStreetMap Dark Container Box with Location Pin
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: location != null
                    ? FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(location.latitude, location.longitude),
                          initialZoom: 15.0,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.neythuaung.attendly',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(location.latitude, location.longitude),
                                width: 36,
                                height: 36,
                                child: Icon(
                                  Icons.location_on,
                                  color: $styles.color.clrPrimary,
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(
                        color: const Color(0xFF031A38),
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            color: Color(0xFF1E88E5),
                            size: 36,
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            /// Address Bold Text
            Text(
              location?.address.isNotEmpty == true
                  ? location!.address
                  : 'Fetching location address...',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 2),

            /// Coordinates Line
            if (location != null)
              Text(
                '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: $styles.color.clrDarkGrey,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
