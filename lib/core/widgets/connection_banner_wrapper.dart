import 'package:app/core/theming/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../dimensions/dimensions_constants.dart';
import '../theming/colors.dart';

class ConnectionBannerWrapper extends StatefulWidget {
  final bool isConnected;
  final Widget child;

  const ConnectionBannerWrapper({
    super.key,
    required this.isConnected,
    required this.child,
  });

  @override
  State<ConnectionBannerWrapper> createState() =>
      _ConnectionBannerWrapperState();
}

class _ConnectionBannerWrapperState extends State<ConnectionBannerWrapper>
    with SingleTickerProviderStateMixin {
  bool showBanner = false;
  Color bannerColor = errorColor;

  @override
  void didUpdateWidget(covariant ConnectionBannerWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isConnected != widget.isConnected) {
      if (!widget.isConnected) {
        // Went offline — show red banner
        setState(() {
          showBanner = true;
          bannerColor = errorColor;
        });
      } else {
        // Back online — show green briefly then hide
        setState(() => bannerColor = AppColor.primaryDark);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => showBanner = false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (showBanner)
          Positioned(
            top: edge * 2.5,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: edge,
                  vertical: edge * 0.5,
                ),
                decoration: BoxDecoration(
                  color: bannerColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.isConnected
                          ? 'connected'.tr()
                          : 'no_internet'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColor.primaryLight,
                      ),
                    ),
                    if (!widget.isConnected) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: AppColor.primaryLight,
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}