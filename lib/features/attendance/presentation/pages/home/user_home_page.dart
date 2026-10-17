import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attendly/di/injector.dart';
import 'package:attendly/shared/components/loading/loading_body.dart';
import 'package:attendly/shared/components/prompt/offline_sync_banner.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'cubit/home_page_cubit.dart';
import 'widget/check_in_out_action_button.dart';
import 'widget/location_card_section.dart';
import 'widget/status_card_section.dart';
import 'widget/user_header_section.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => inject<HomePageCubit>(),
      child: Scaffold(
        body: BlocBuilder<HomePageCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomePageCubit>();
            final isLoading = state is HomeInitial && state.isLoading;
            final currentLocation = state is HomeInitial ? state.currentLocation : null;

            if (isLoading && currentLocation == null) {
              return const LoadingBody();
            }

            final unsyncedCount = state is HomeInitial ? state.unsyncedCount : 0;
            final isOffline = state is HomeInitial && state.isOffline;

            return RefreshIndicator(
              onRefresh: () async {
                await cubit.syncOffline();
                await cubit.fetchLocationAndStatus();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  16,
                  context.mediaQuery.padding.top + 12,
                  16,
                  context.bottomPadding + 15,
                ),
                child: Column(
                  children: [
                    /// User Greeting & Avatar Header
                    const UserHeaderSection(),

                    const SizedBox(height: 12),

                    /// Offline / Pending Sync Banner
                    if (isOffline || unsyncedCount > 0)
                      OfflineSyncBanner(
                        unsyncedCount: unsyncedCount,
                        isOffline: isOffline,
                      ),

                    /// Status Card Section (Check-In Status, Current Date & Check-In Time)
                    StatusCardSection(state: state),

                    const SizedBox(height: 12),

                    /// Location Card with Map Preview & Location Icon
                    LocationCardSection(state: state),

                    const SizedBox(height: 16),

                    /// Check In / Check Out Action Button
                    CheckInOutActionButton(state: state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
