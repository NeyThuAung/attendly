import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attendly/shared/components/loading/loading_body.dart';
import 'package:attendly/shared/components/prompt/error_view.dart';
import 'cubit/user_history_cubit.dart';
import 'widget/user_history_ready_page.dart';

class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: BlocBuilder<UserHistoryCubit, UserHistoryState>(
        builder: (context, state) {
          if (state is UserHistoryReady) {
            return UserHistoryReadyPage(
              logs: state.logs,
              syncedLogs: state.syncedLogs,
              unsyncedLogs: state.unsyncedLogs,
              isOffline: state.isOffline,
              unsyncedCount: state.unsyncedCount,
            );
          } else if (state is UserHistoryError) {
            return ErrorView(
              onRetry: () {
                context.read<UserHistoryCubit>().loadHistory(showLoading: true);
              },
              error: state.error,
            );
          }
          return const LoadingBody();
        },
      ),
    );
  }
}
