import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:attendly/di/injector.dart';
import 'package:attendly/features/auth/domain/entity/user_entity.dart';
import 'package:attendly/shared/components/loading/loading_body.dart';
import 'package:attendly/shared/components/wrapper/dismiss_focus_wrapper.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'cubit/users_list_cubit.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DismissFocusWrapper(
      child: BlocProvider(
        create: (_) => inject<UsersListCubit>(),
        child: BlocBuilder<UsersListCubit, UsersListState>(
          builder: (context, state) {
            final cubit = context.read<UsersListCubit>();
            final isLoading = state is UsersListInitial && state.isLoading;
            final isLoadingMore = state is UsersListInitial && state.isLoadingMore;
            final hasReachedMax = state is UsersListInitial && state.hasReachedMax;
            final users = state is UsersListInitial ? state.users : <UserEntity>[];
            final searchQuery = state is UsersListInitial ? state.searchQuery : null;

            final showFooter = isLoadingMore || (hasReachedMax && users.isNotEmpty);

            return Scaffold(
              appBar: AppBar(title: const Text('Employees')),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all($styles.insets.sm),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      onChanged: (q) => cubit.searchUsers(query: q),
                      decoration: InputDecoration(
                        hintText: 'Search employee . . .',
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 12, right: 5),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 22,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 48,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? context.theme.cardColor : Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await cubit.searchUsers(query: searchQuery, forceReload: true);
                      },
                      child: isLoading && users.isEmpty
                          ? const LoadingBody()
                          : users.isEmpty
                              ? SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                    height: 300,
                                    alignment: Alignment.center,
                                    child: const Text('No employees found.'),
                                  ),
                                )
                              : NotificationListener<ScrollNotification>(
                                  onNotification: (ScrollNotification scrollInfo) {
                                    if (scrollInfo.metrics.pixels >=
                                        scrollInfo.metrics.maxScrollExtent - 200) {
                                      cubit.loadMoreUsers();
                                    }
                                    return false;
                                  },
                                  child: ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      bottom: context.bottomPadding + 15,
                                    ),
                                    itemCount: users.length + (showFooter ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index == users.length) {
                                        if (isLoadingMore) {
                                          return const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 16),
                                            child: Center(
                                              child: SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          child: Center(
                                            child: Text(
                                              'No more employees',
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: $styles.color.clrDarkGrey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final user = users[index];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: user.profileImageUrl != null
                                              ? NetworkImage(user.profileImageUrl!)
                                              : null,
                                          child: user.profileImageUrl == null
                                              ? Text(user.name.isNotEmpty
                                                  ? user.name[0].toUpperCase()
                                                  : 'U')
                                              : null,
                                        ),
                                        title: Text(user.name),
                                        subtitle: Text(user.email),
                                        trailing: Chip(
                                          label: Text(
                                            (user.role == UserRole.admin
                                                ? 'ADMIN'
                                                : 'EMPLOYEE'),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor: user.isAdmin
                                              ? Colors.indigo.shade100
                                              : Colors.grey.shade200,
                                        ),
                                      );
                                    },
                                  ),
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
