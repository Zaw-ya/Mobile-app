import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/title_text.dart';


class LogoutBottomSheet extends StatefulWidget {
  const LogoutBottomSheet({super.key});

  @override
  State<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
}

class _LogoutBottomSheetState extends State<LogoutBottomSheet> {
  bool _isAnimating = false;

  Future<void> _handleLogout() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: false);
      await AppUtilities().clearData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.5,
      builder: (context, scrollController) => AnimatedOpacity(
        opacity: _isAnimating ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 400),
        child: AnimatedScale(
          scale: _isAnimating ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 400),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(containerRadius),
                topRight: Radius.circular(containerRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: EdgeInsets.all(edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _isAnimating ? null : () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.all(edge * 0.6),
                        decoration: BoxDecoration(
                          color: AppColor.gray50,
                          shape: BoxShape.circle,
                        ),
                        child:  Icon(Icons.close, color: AppColor.gray900),
                      ),
                    ),
                    SizedBox(width: edge * 0.6),
                    TitleText(
                      text: "logout".tr(),
                      color: AppColor.mainRed,
                      fontSize: 20,
                      align: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: edge * 0.9),
                NormalText(
                  text: "logout_hint".tr(),
                  fontSize: 18,
                  color: AppColor.gray600,
                  align: TextAlign.start,
                ),
                SizedBox(height: edge * 1.5),
                CustomButton.normal(
                  text: "logout".tr(),
                  color: AppColor.mainRed,
                  textColor: AppColor.whiteColor,
                  onPressed: _isAnimating ? null : _handleLogout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
