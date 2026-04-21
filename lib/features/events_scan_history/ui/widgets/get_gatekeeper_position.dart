import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import '../../../../core/widgets/loaders.dart';

class LocationService {
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<Position> getPosition(BuildContext context) async {
    if (!context.mounted) return _defaultPosition();

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!context.mounted) return _defaultPosition();
        bool enabled = await _requestLocationService();
        if (!enabled) {
          if (!context.mounted) return _defaultPosition();
          await _handleLocationDisabled(context);
          return _defaultPosition();
        }
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!context.mounted) return _defaultPosition();
          await _handlePermissionDenied(context);
          return _defaultPosition();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!context.mounted) return _defaultPosition();
        await _handlePermissionDeniedForever(context);
        return _defaultPosition();
      }

      // Get position with timeout
      final Position position =
          await Geolocator.getCurrentPosition().timeout(timeoutDuration);

      return position;
    } catch (e) {
      if (!context.mounted) return _defaultPosition();
      await _showErrorDialog(
        context,
        'error'.tr(),
        'location_not_available'.tr(),
        'retry'.tr(),
      );
      return _defaultPosition();
    }
  }

  static Future<bool> _requestLocationService() async {
    final loc.Location location = loc.Location();
    try {
      return await location.requestService();
    } catch (e) {
      return false;
    }
  }

  static Future<void> _handleLocationDisabled(BuildContext context) async {
    await _showErrorDialog(
      context,
      'error'.tr(),
      'location_service_disabled'.tr(),
      'enable_location_service'.tr(),
    );
  }

  static Future<void> _handlePermissionDenied(BuildContext context) async {
    await _showErrorDialog(
      context,
      'error'.tr(),
      'location_permission_denied_short'.tr(),
      'open_settings'.tr(),
    );
  }

  static Future<void> _handlePermissionDeniedForever(
      BuildContext context) async {
    await _showErrorDialog(
      context,
      'error'.tr(),
      'location_permission_denied_long'.tr(),
      'open_settings'.tr(),
    );
  }

  static Future<void> _showErrorDialog(
    BuildContext context,
    String title,
    String message,
    String actionText,
  ) async {
    if (!context.mounted) return;

    return dialogWithSingleAction(
      context: context,
      title: title,
      msg: message,
      actionText: actionText,
      onActionTap: () async {
        await Geolocator.openLocationSettings();
        if (context.mounted) {
          context.pop();
        }
      },
    );
  }

  static Position _defaultPosition() {
    return Position(
      longitude: -1,
      latitude: -1,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}
