import 'package:app/generated/fonts.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theming/colors.dart';
import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/helpers/date_time_helper.dart';
import '../../notifications/logic/notifications_cubit.dart';
import '../../notifications/logic/notifications_states.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final atBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;

    if (atBottom) {
      context.read<NotificationsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title:  Text('notifications'.tr(),
            style: TextStyle(fontFamily: FontFamily.manchetteFine, color: AppColor.whiteColor)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColor.whiteColor),
        ),
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
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(edge),
                    // +1 عشان الـ loading indicator في الآخر
                    itemCount: list.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (ctx, idx) {
                      // last item = loading indicator
                      if (idx == list.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final n = list[idx];
                      return Container(
                        decoration: BoxDecoration(
                          color: n.read
                              ? null
                              : AppColor.primaryColor.withValues(alpha: 0.1),
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
                              fontFamily: FontFamily.manchetteFine,
                              fontWeight: n.read
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.body),
                              const SizedBox(height: 4),
                              Text(
                                DateTimeHelper.toRelativeTime(n.createdAt),
                                style: TextStyle(
                                  fontFamily: FontFamily.manchetteFine,
                                  fontSize: 11.sp,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          trailing: n.read
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.done,
                                      color: AppColor.primaryColor),
                                  onPressed: () => context
                                      .read<NotificationsCubit>()
                                      .markRead(n.id),
                                ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}