import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theming/colors.dart';
import '../../../core/dimensions/dimensions_constants.dart';
import '../../notifications/logic/notifications_cubit.dart';
import '../../notifications/logic/notifications_states.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Notifications',
            style: TextStyle(color: AppColor.whiteColor)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.whiteColor,
            )),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsStates>(
        builder: (context, state) {
          if (state is NotificationsLoading && state.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsError && state.notifications.isEmpty) {
            return Center(child: Text('Error: ${state.message}'));
          }

          final list = state.notifications;

          return RefreshIndicator(
            onRefresh: () =>
                context.read<NotificationsCubit>().loadNotifications(),
            child: list.isEmpty
                ? const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 400,
                      child: Center(child: Text('No notifications yet.')),
                    ),
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(edge),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (ctx, idx) {
                      final n = list[idx];
                      return Container(
                        decoration: BoxDecoration(
                          color: n.read
                              ? null
                              : AppColor.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: n.read ? Colors.grey : AppColor.primaryColor,
                          ),
                          title: Text(
                            n.title,
                            style: TextStyle(
                              fontWeight:
                                  n.read ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(n.body),
                          trailing: n.read
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.done,
                                      color: Colors.green),
                                  onPressed: () => context
                                      .read<NotificationsCubit>()
                                      .markRead(n.id),
                                ),
                        ),
                      );
                    },
                  ),
          );
          // }

          // return const SizedBox.shrink();
        },
      ),
    );
  }
}
