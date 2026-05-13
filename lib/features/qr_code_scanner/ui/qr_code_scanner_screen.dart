import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/title_text.dart';
import 'package:app/features/qr_code_scanner/logic/qr_code_scanner_cubit.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:app/core/helpers/extensions.dart';
import '../../../core/dimensions/dimensions_constants.dart';
import '../../../core/services/audio_service.dart';
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
  // bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
  }

  @override
  void dispose() {
    _isDisposed = true;
    // Safely dispose of scanner controller
    _scannerController?.dispose();
    _scannerController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocProvider.of instead of context.read to safely access cubit
    final cubit = BlocProvider.of<QrCodeScannerCubit>(context, listen: false);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bgColor,
        body: cubit.stopScan
            ? Container(color: Colors.black)
            : BlocBuilder<QrCodeScannerCubit, QrCodeScannerStates>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, current) {
                  return current.when(
                    initial: () => _scannerView(context, cubit),
                    loading: () => Center(child: Loader(color: whiteTextColor)),
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
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: (capture) async {
            if (_isDisposed || cubit.stopScan) {
              return; // Skip if already scanning or disposed
            }
            // _isProcessing = true;
            cubit.scanStartTime = DateTime.now().toString();
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null &&
                  cubit.isValidBase64(barcode.rawValue!)) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                await cubit.scanQrCode(
                  barcode.rawValue!,
                  widget.eventId
                );
                break; // stop after first valid scan
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

      // Start playing audio immediately
      try {
        AudioService().playAudio(
          src: 'sounds/audSuccess.mp3',
        );
      } catch (e) {
        debugPrint('Error playing audio: $e');
      }

      // Show the dialog
      _showColoredAlert(
        context: context,
        title: "qr_verified".tr(),
        message: response.message ?? "",
        correct: true,
        color: Colors.grey.shade200,
        onClose: () {
          if (!mounted || _isDisposed) return;
          //Future.delayed(const Duration(milliseconds: 200), () {
          // Delay the reset
          // if (!mounted || _isDisposed) return;
          try {
            context.read<QrCodeScannerCubit>().reloadPage();
            //  _scannerController?.start();
            //  _isProcessing = false; // Then reset _isProcessing after dialog close
          } catch (e) {
            debugPrint('Error reloading page: $e');
          }
          // });
        },
      );
    });

    return const SizedBox.shrink();
  }

  Widget _handleError(BuildContext context, String error) {
    if (!mounted || _isDisposed) return const SizedBox.shrink();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;

      // Start playing audio immediately
      try {
        AudioService().playAudio(
          src: 'sounds/audFailure.mp3',
        );
      } catch (e) {
        debugPrint('Error playing audio: $e');
      }

      // Show the dialog
      _showColoredAlert(
        context: context,
        title: "error".tr(),
        message: error.contains("Scanned 1 of 1")
            ? "scanned_before".tr()
            : error.contains("Event is out dated")
                ? "event_outdated".tr()
                : error.contains("Event is not assigned to you")
                    ? "event_is_not_assigned_to_you".tr()
                    : error.contains("Event is not yet started")
                        ? "event_is_not_yet_started".tr()
                        : error,
        correct: false,
        color: Colors.grey.shade200,
        onClose: () {
          if (!mounted || _isDisposed) return;
          try {
            context.read<QrCodeScannerCubit>().reloadPage();
            // _scannerController?.start();
          } catch (e) {
            debugPrint('Error reloading page: $e');
          }
        },
      );
    });

    return const SizedBox.shrink();
  }

  void _showColoredAlert({
    required BuildContext context,
    required String title,
    required bool correct,
    required String message,
    required Color color,
    required VoidCallback onClose,
  }) {
    if (!mounted || _isDisposed) return;

    Widget okButton = TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        padding:
            WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(edge * 0.7)),
        minimumSize: WidgetStateProperty.all<Size>(const Size(110, 40)),
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
      child: TitleText(
        text: "continue".tr(),
        color: Colors.white,
        fontSize: 16,
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: color,
      title: Column(
        children: [
          correct
              ? const Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 60,
                )
              : const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 60,
                ),
          const SizedBox(
            height: 12,
          ),
          TitleText(
            text: title,
            color: Colors.grey.shade900,
            fontSize: 20,
          ),
        ],
      ),
      content: NormalText(
        text: message,
        fontSize: 16,
        color: Colors.grey.shade900,
      ),
      actions: [okButton],
    );

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } catch (e) {
      debugPrint('Error showing dialog: $e');
    }
  }
}
