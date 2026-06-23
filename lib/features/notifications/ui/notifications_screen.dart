import 'package:app/generated/fonts.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app/core/theming/typography_theme.dart';
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
    if (atBottom) context.read<NotificationsCubit>().loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryLight,
      appBar: AppBar(
        backgroundColor: AppColor.primaryDark,
        elevation: 0,
        title: Text(
          'notifications'.tr(),
          style: context.typography.titleLarge.copyWith(color: AppColor.primaryLight),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColor.primaryLight),
        ),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsStates>(
        builder: (context, state) {
          if (state is NotificationsLoading && state.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryDark),
            );
          }

          if (state is NotificationsError && state.notifications.isEmpty) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: context.typography.bodyMedium
                    .copyWith(color: AppColor.semanticError),
              ),
            );
          }

          final list = state.notifications;

          return RefreshIndicator(
            color: AppColor.primaryDark,
            onRefresh: () =>
                context.read<NotificationsCubit>().loadNotifications(),
            child: list.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 400,
                      child: Center(
                        child: Text(
                          'no_notifications'.tr(),
                          style: context.typography.bodyMedium
                              .copyWith(color: AppColor.gray500),
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(edge),
                    itemCount: list.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColor.gray100, height: 1),
                    itemBuilder: (ctx, idx) {
                      if (idx == list.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryDark,
                            ),
                          ),
                        );
                      }

                      final n = list[idx];
                      return Container(
                        decoration: BoxDecoration(
                          color: n.read
                              ? Colors.white
                              : AppColor.primaryDark.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(radiusInput),
                          border: Border.all(color: AppColor.gray100),
                        ),
                        margin: EdgeInsets.only(bottom: edge * 0.3),
                        child: ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: n.read
                                ? AppColor.gray400
                                : AppColor.primaryDark,
                          ),
                          title: Text(
                            n.title,
                            style: context.typography.titleSmall.copyWith(
                              color: AppColor.primaryDark,
                              fontWeight: n.read
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.body,
                                style: context.typography.bodySmall
                                    .copyWith(color: AppColor.gray700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateTimeHelper.toRelativeTime(n.createdAt),
                                style: TextStyle(
                                  fontFamily: FontFamily.manchetteFine,
                                  fontSize: 11.sp,
                                  color: AppColor.gray400,
                                ),
                              ),
                            ],
                          ),
                          trailing: n.read
                              ? null
                              : IconButton(
                                  icon: const Icon(
                                    Icons.done,
                                    color: AppColor.primaryDark,
                                  ),
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
