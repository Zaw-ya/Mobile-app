import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/dimensions/dimensions_constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';

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
    final String newCode = context.locale.languageCode == 'en' ? 'ar' : 'en';

    await _controller.forward();
    if (!mounted) return;

    AppUtilities().setLocality(newCode);
    if (!mounted) return;

    await _controller.reverse();
  }

  Future<void> _handleLogout() async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: whiteTextColor,
        title: NormalText(
          text: 'logout_confirmation_title'.tr(),
          color: navBarBackground,
          fontSize: 20,
          align: TextAlign.start,
        ),
        content: NormalText(
          text: 'logout_confirmation_message'.tr(),
          color: navBarBackground,
          fontSize: 16,
          align: TextAlign.start,
        ),
        actions: [
          GoButton(
            fun: () => context.pop(),
            titleKey: 'cancel'.tr(),
            textColor: whiteTextColor,
            fontSize: 16,
            btColor: Colors.red,
            w: 100,
          ),
          GoButton(
            fun: () async {
              try {
                context.pushNamedAndRemoveUntil(Routes.loginScreen,
                    predicate: false);
                await AppUtilities().clearData();
              } catch (e) {
                debugPrint('Logout error: $e');
              }
            },
            titleKey: 'logout'.tr(),
            textColor: whiteTextColor,
            fontSize: 16,
            w: 120,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(edge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const Divider(height: 24, color: bgColorOverlay),
              SizedBox(height: edge),
              _buildSettingsOption(
                context: context,
                child: _buildLanguageButton(context),
              ),
              SizedBox(height: edge),
              _buildSettingsOption(
                context: context,
                child: _buildLogoutButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return TitleText(
      text: 'settings'.tr(),
      color: Colors.white,
      fontSize: 24,
    );
  }

  Widget _buildSettingsOption(
      {required BuildContext context, required Widget child}) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColorOverlay,
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
                child: NormalText(
                  text: 'changeLanguage'.tr(),
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: TitleText(
                  text: context.locale.languageCode == 'en' ? 'AR' : 'En',
                  color: Colors.white,
                  fontSize: 20,
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
                  child: NormalText(
                    text: 'logout'.tr(),
                    color: Colors.white,
                    fontSize: 18,
                    align: TextAlign.start,
                  ),
                ),
              ),
              Transform.rotate(
                angle: context.locale.languageCode == 'en' ? 0 : 3.14,
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
