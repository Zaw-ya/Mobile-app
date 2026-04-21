import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:app/core/widgets/custom_button.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/theming/colors.dart';

class RateAppBottomSheet extends StatefulWidget {
  const RateAppBottomSheet({super.key});

  @override
  State<RateAppBottomSheet> createState() => _RateAppBottomSheetState();
}

class _RateAppBottomSheetState extends State<RateAppBottomSheet> {
  bool _isRequesting = false;

  Future<void> _requestReview() async {
    if (_isRequesting) return;
    setState(() => _isRequesting = true);

    try {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing();
      }
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.45,
      builder: (context, scrollController) => AnimatedOpacity(
        opacity: _isRequesting ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 400),
        child: AnimatedScale(
          scale: _isRequesting ? 0.98 : 1.0,
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
                // ── Header ───────────────────────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: _isRequesting ? null : () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.all(edge * 0.6),
                        decoration: BoxDecoration(
                          color: AppColor.gray50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: AppColor.gray900),
                      ),
                    ),
                    SizedBox(width: edge * 0.6),
                    TitleText(
                      text: "rate_app".tr(),
                      color: AppColor.primaryColor,
                      fontSize: 20,
                      align: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: edge * 0.9),

                // ── Hint ─────────────────────────────────────────────────
                NormalText(
                  text: "rate_app_hint".tr(),
                  fontSize: 16,
                  color: AppColor.gray600,
                  align: TextAlign.start,
                ),
                SizedBox(height: edge * 1.5),

                // ── Button — triggers native store popup ──────────────────
                CustomButton.normal(
                  text: "rate_now".tr(),
                  color: AppColor.primaryColor,
                  textColor: AppColor.whiteColor,
                  onPressed: _isRequesting ? null : _requestReview,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}