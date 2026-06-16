import 'package:app/features/qr_code_scanner/logic/qr_code_scanner_cubit.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:app/core/helpers/extensions.dart';

import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theming/app_typography.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/widgets/public_app_bar.dart';
import '../data/models/scan_response.dart';
import '../logic/qr_code_scanner_states.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key, required this.eventId});
  final int eventId;

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  MobileScannerController? _scannerController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scannerController?.dispose();
    _scannerController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<QrCodeScannerCubit>(context, listen: false);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColor.primaryDark,
        body: cubit.stopScan
            ? const ColoredBox(color: Colors.black, child: SizedBox.expand())
            : BlocBuilder<QrCodeScannerCubit, QrCodeScannerStates>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, current) {
                  return current.when(
                    initial: () => _scannerView(context, cubit),
                    loading: () => Center(
                      child: Loader(color: AppColor.primaryLight),
                    ),
                    emptyInput: () => const SizedBox.shrink(),
                    success: (response) => _handleSuccess(context, response),
                    error: (error) => _handleError(context, error),
                  );
                },
              ),
      ),
    );
  }

  Widget _scannerView(BuildContext context, QrCodeScannerCubit cubit) {
    if (_scannerController == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryLight),
      );
    }

    return Stack(
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: (capture) async {
            if (_isDisposed || cubit.stopScan) return;
            cubit.scanStartTime = DateTime.now().toString();
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null &&
                  cubit.isValidBase64(barcode.rawValue!)) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                await cubit.scanQrCode(barcode.rawValue!, widget.eventId);
                break;
              } else {
                debugPrint('Not valid barcode ${barcode.rawValue}');
              }
            }
          },
        ),
        SizedBox(
          height: 110,
          child: recordsAppBar(context, 'scan_qr'.tr()),
        ),
      ],
    );
  }

  Widget _handleSuccess(BuildContext context, ScanResponse response) {
    if (!mounted || _isDisposed) return const SizedBox.shrink();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;
      try {
        AudioService().playAudio(src: 'sounds/audSuccess.mp3');
      } catch (e) {
        debugPrint('Error playing audio: $e');
      }
      _showScanAlert(
        context: context,
        title: 'qr_verified'.tr(),
        message: response.message ?? '',
        isSuccess: true,
        onClose: () {
          if (!mounted || _isDisposed) return;
          try {
            context.read<QrCodeScannerCubit>().reloadPage();
          } catch (e) {
            debugPrint('Error reloading page: $e');
          }
        },
      );
    });

    return const SizedBox.shrink();
  }

  Widget _handleError(BuildContext context, String error) {
    if (!mounted || _isDisposed) return const SizedBox.shrink();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;
      try {
        AudioService().playAudio(src: 'sounds/audFailure.mp3');
      } catch (e) {
        debugPrint('Error playing audio: $e');
      }
      _showScanAlert(
        context: context,
        title: 'error'.tr(),
        message: error.contains('Scanned 1 of 1')
            ? 'scanned_before'.tr()
            : error.contains('Event is out dated')
                ? 'event_outdated'.tr()
                : error.contains('Event is not assigned to you')
                    ? 'event_is_not_assigned_to_you'.tr()
                    : error.contains('Event is not yet started')
                        ? 'event_is_not_yet_started'.tr()
                        : error,
        isSuccess: false,
        onClose: () {
          if (!mounted || _isDisposed) return;
          try {
            context.read<QrCodeScannerCubit>().reloadPage();
          } catch (e) {
            debugPrint('Error reloading page: $e');
          }
        },
      );
    });

    return const SizedBox.shrink();
  }

  void _showScanAlert({
    required BuildContext context,
    required String title,
    required bool isSuccess,
    required String message,
    required VoidCallback onClose,
  }) {
    if (!mounted || _isDisposed) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: AppColor.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusInput),
          ),
          title: Column(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.cancel,
                color: isSuccess
                    ? AppColor.primaryDark
                    : AppColor.semanticError,
                size: 60,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.titleLarge
                    .copyWith(color: AppColor.primaryDark),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColor.gray700),
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColor.primaryDark),
                  foregroundColor:
                      WidgetStateProperty.all(AppColor.primaryLight),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: edge * 0.7),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radiusInput),
                    ),
                  ),
                ),
                onPressed: () {
                  if (!mounted || _isDisposed) return;
                  try {
                    context.pop();
                    onClose();
                  } catch (e) {
                    debugPrint('Error during dialog close: $e');
                  }
                },
                child: Text(
                  'continue'.tr(),
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColor.primaryLight),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Error showing dialog: $e');
    }
  }
}
