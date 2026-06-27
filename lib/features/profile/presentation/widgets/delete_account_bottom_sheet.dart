import 'package:app/core/dimensions/dimensions_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/routing/routes.dart';
import 'package:app/core/theming/typography_theme.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../logic/profile_cubit.dart';
import '../../logic/profile_states.dart';

// Two-step account deletion flow:
//   Step 0 — Warning: explains what deletion means, first confirmation
//   Step 1 — Final confirmation: deliberate second tap calls the API
//
// isDismissible and enableDrag are both false (set by ProfileMenu) so the
// user cannot swipe away mid-request.
class DeleteAccountBottomSheet extends StatefulWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  State<DeleteAccountBottomSheet> createState() =>
      _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends State<DeleteAccountBottomSheet> {
  int _step = 0;

  Future<void> _onConfirmDelete() async {
    context.read<ProfileCubit>().deleteAccount();
  }

  Future<void> _onSuccess() async {
    await AppUtilities().clearData();
    if (!mounted) return;
    context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listenWhen: (_, current) => current.maybeWhen(
        deletingAccount: () => false,
        deleteAccountSuccess: () => true,
        deleteAccountError: (_) => true,
        orElse: () => false,
      ),
      listener: (context, state) {
        state.whenOrNull(
          deleteAccountSuccess: _onSuccess,
          deleteAccountError: (msg) {
            context.showErrorToast(msg);
            setState(() => _step = 0);
          },
        );
      },
      buildWhen: (_, current) => current.maybeWhen(
        deletingAccount: () => true,
        deleteAccountSuccess: () => true,
        deleteAccountError: (_) => true,
        orElse: () => false,
      ),
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          deletingAccount: () => true,
          orElse: () => false,
        );

        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.35,
          maxChildSize: 0.65,
          builder: (_, scrollController) => AnimatedOpacity(
            opacity: isLoading ? 0.6 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _step == 0
                    ? _WarningStep(
                        key: const ValueKey(0),
                        isLoading: isLoading,
                        onContinue: () => setState(() => _step = 1),
                        onCancel: () => Navigator.pop(context),
                      )
                    : _ConfirmStep(
                        key: const ValueKey(1),
                        isLoading: isLoading,
                        onConfirm: _onConfirmDelete,
                        onBack: () => setState(() => _step = 0),
                        onCancel: () => Navigator.pop(context),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Step 0: Warning ────────────────────────────────────────────────────────────

class _WarningStep extends StatelessWidget {
  const _WarningStep({
    super.key,
    required this.isLoading,
    required this.onContinue,
    required this.onCancel,
  });

  final bool isLoading;
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: isLoading ? null : onCancel,
              child: Container(
                padding: EdgeInsets.all(edge * 0.6),
                decoration: const BoxDecoration(
                  color: AppColor.gray100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: AppColor.gray700, size: 20),
              ),
            ),
            SizedBox(width: edge * 0.6),
            Text(
              'delete_account_warning_title'.tr(),
              style: context.typography.titleLarge
                  .copyWith(color: AppColor.semanticError),
            ),
          ],
        ),
        SizedBox(height: edge),
        Text(
          'delete_account_warning_body'.tr(),
          style: context.typography.bodyMedium.copyWith(color: AppColor.gray700),
        ),
        SizedBox(height: edge * 1.5),
        Row(
          children: [
            Expanded(
              child: CustomButton.normal(
                text: 'cancel'.tr(),
                color: AppColor.gray200,
                textColor: AppColor.primaryDark,
                onPressed: isLoading ? null : onCancel,
              ),
            ),
            SizedBox(width: edge * 0.6),
            Expanded(
              child: CustomButton.normal(
                text: 'delete_account_confirm_btn'.tr(),
                color: AppColor.semanticError,
                textColor: Colors.white,
                fontSize: 13.sp,
                onPressed: isLoading ? null : onContinue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Step 1: Final confirmation — API call fires here ──────────────────────────

class _ConfirmStep extends StatelessWidget {
  const _ConfirmStep({
    super.key,
    required this.isLoading,
    required this.onConfirm,
    required this.onBack,
    required this.onCancel,
  });

  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: isLoading ? null : onBack,
              child: Container(
                padding: EdgeInsets.all(edge * 0.6),
                decoration: const BoxDecoration(
                  color: AppColor.gray100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppColor.gray700, size: 20),
              ),
            ),
            SizedBox(width: edge * 0.6),
            Text(
              'delete_account_confirm_title'.tr(),
              style: context.typography.titleLarge
                  .copyWith(color: AppColor.semanticError),
            ),
          ],
        ),
        SizedBox(height: edge),
        Text(
          'delete_account_confirm_body'.tr(),
          style: context.typography.bodyMedium.copyWith(color: AppColor.gray700),
        ),
        SizedBox(height: edge * 1.5),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              color: AppColor.semanticError,
              strokeWidth: 2.5,
            ),
          )
        else ...[
          CustomButton.normal(
            text: 'delete_account_confirm_btn'.tr(),
            color: AppColor.semanticError,
            textColor: Colors.white,
            onPressed: onConfirm,
          ),
          SizedBox(height: edge * 0.6),
          Center(
            child: TextButton(
              onPressed: onCancel,
              child: Text(
                'cancel'.tr(),
                style: context.typography.labelMedium
                    .copyWith(color: AppColor.gray500),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
