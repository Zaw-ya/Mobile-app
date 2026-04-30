import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/title_text.dart';
import '../../../../generated/assets.dart';
import '../services/notification_service.dart';
import '../routing/routes.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../features/notifications/logic/notifications_cubit.dart';

class ClientHeader extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final int? notificationCount; // if null, widget will fetch dynamic count

  const ClientHeader(
      {super.key,
      required this.title,
      required this.subTitle,
      this.notificationCount});

  @override
  State<ClientHeader> createState() => _ClientHeaderState();
}

class _ClientHeaderState extends State<ClientHeader> {
  int _count = 0;
  bool _loading = false;
  late final NotificationsCubit _notificationsCubit;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _notificationsCubit = getIt<NotificationsCubit>();

    if (widget.notificationCount != null) {
      _count = widget.notificationCount!;
    } else {
      _loadCombinedCount();
    }
    _subscription = _notificationsCubit.stream.listen((_) {
      if (mounted) _loadCombinedCount();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _loadCombinedCount() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final local   = await NotificationService().getPendingNotifications();
      final backend = _notificationsCubit.backendUnreadCount;
      if (mounted) setState(() => _count = local.length + backend);
    } catch (_) {
      if (mounted) setState(() => _count = 0);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.only(
          top: edge * 2.5, bottom: edge, left: edge, right: edge),
      decoration: BoxDecoration(color: AppColor.homeBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: widget.subTitle ?? "",
                color: AppColor.gray700,
                fontSize: 16,
              ),
              TitleText(
                  text: widget.title ?? "",
                  fontSize: 25,
                  color: AppColor.primaryColor),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Open Notifications list (app) when bell is tapped
              Navigator.of(context).pushNamed(Routes.notifications);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Bell container ─────────────────────────────────────────
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.svgsNotifications,
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),

                // ── Badge ──────────────────────────────────────────────────
                if ((_loading == false) && (_count > 0))
                  Positioned(
                    bottom: -6,
                    right: isArabic ? -10 : null,
                    left: isArabic ? null : -10,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 30),
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColor.mainRed,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColor.whiteColor,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: TitleText(
                          text: _count > 99 ? '99+' : '$_count',
                          fontSize: 16,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
