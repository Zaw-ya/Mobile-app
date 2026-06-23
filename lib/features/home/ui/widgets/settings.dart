import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/theming/typography_theme.dart';
import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/routing/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateLanguageChange(BuildContext context) async {
    final String newCode =
        context.locale.languageCode == 'en' ? 'ar' : 'en';
    await _controller.forward();
    if (!mounted) return;
    AppUtilities().setLocality(newCode);
    if (!mounted) return;
    await _controller.reverse();
  }

  Future<void> _handleLogout() async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: AppColor.primaryLight,
        title: Text(
          'logout_confirmation_title'.tr(),
          style: context.typography.titleMedium.copyWith(color: AppColor.primaryDark),
        ),
        content: Text(
          'logout_confirmation_message'.tr(),
          style: context.typography.bodyMedium.copyWith(color: AppColor.gray700),
        ),
        actions: [
          CustomButton.normal(
            text: 'cancel'.tr(),
            color: AppColor.gray200,
            textColor: AppColor.primaryDark,
            onPressed: () => ctx.pop(),
          ),
          CustomButton.normal(
            text: 'logout'.tr(),
            color: AppColor.semanticError,
            textColor: Colors.white,
            onPressed: () async {
              try {
                ctx.pushNamedAndRemoveUntil(Routes.loginScreen,
                    predicate: false);
                await AppUtilities().clearData();
              } catch (e) {
                debugPrint('Logout error: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(edge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Divider(
                height: 24,
                color: AppColor.primaryLight.withValues(alpha: 0.2),
              ),
              SizedBox(height: edge),
              _buildSettingsOption(child: _buildLanguageButton(context)),
              SizedBox(height: edge),
              _buildSettingsOption(child: _buildLogoutButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'settings'.tr(),
      style: context.typography.titleLarge.copyWith(color: AppColor.primaryLight),
    );
  }

  Widget _buildSettingsOption({required Widget child}) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.primaryLight.withValues(alpha: 0.1),
      ),
      child: child,
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _animateLanguageChange(context),
        child: Padding(
          padding: EdgeInsets.all(edge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'changeLanguage'.tr(),
                  style: context.typography.bodyMedium
                      .copyWith(color: AppColor.primaryLight),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  context.locale.languageCode == 'en' ? 'AR' : 'En',
                  style: context.typography.titleSmall
                      .copyWith(color: AppColor.primaryLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleLogout,
        child: Padding(
          padding: EdgeInsets.all(edge),
          child: Row(
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'logout'.tr(),
                    style: context.typography.bodyMedium
                        .copyWith(color: AppColor.semanticError),
                  ),
                ),
              ),
              Transform.rotate(
                angle:
                    context.locale.languageCode == 'en' ? 0 : 3.14,
                child: const Icon(Icons.logout, color: AppColor.semanticError),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
