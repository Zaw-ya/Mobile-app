import 'dart:io';

import 'package:app/core/helpers/extensions.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_appbar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver{
  CameraController? controller; // Make nullable
  bool initialized = false;
  bool isTakingPicture = false;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  // ✅ NEW: separate flag — true only after initialize() fully completes
  bool _isInitialized = false;

  Future<void> _initializeCameraController([int? cameraIndex]) async {
    try {
      // Get available cameras if not already fetched
      if (cameras.isEmpty) {
        cameras = await availableCameras();
        if (cameras.isEmpty) throw CameraException('noCameras', 'No cameras available');

      }

      // Use provided index or default to front camera
      if (cameraIndex != null) {
        selectedCameraIndex = cameraIndex;
      } else {
        selectedCameraIndex = cameras.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
        if (selectedCameraIndex == -1) selectedCameraIndex = 0;
      }

      // ✅ Dispose old controller safely before creating new one
      if (_isInitialized && controller != null) {
        _isInitialized = false;
        await controller!.dispose();
        controller = null;
      }

      if (!mounted) return;

      if (mounted) setState(() => initialized = false);

      final newController = CameraController(
        cameras[selectedCameraIndex],
        ResolutionPreset.high,
      );
      controller = newController;

      await newController.initialize();

      // ✅ Check if widget is still alive AND this controller is still current
      if (!mounted || controller != newController) {
        await newController.dispose();
        return;
      }

      await newController.setZoomLevel(1.0);

      _isInitialized = true;  // ✅ only set AFTER initialize() completes
      setState(() => initialized = true);
    } catch (e) {
      if (mounted) context.showErrorToast("cameraInitFailed".tr());
      debugPrint('Camera init error: $e');

    }
  }

  void _switchCamera() async {
    if (cameras.length < 2) return;
    final nextIndex = (selectedCameraIndex + 1) % cameras.length;
    await _initializeCameraController(nextIndex);
  }

  void _handleCameraError(Object error, {String? message}) {
    final errorMessage = message ?? "unexpectedError".tr();
    context.showErrorToast(errorMessage);
    debugPrint('Camera Error: $error');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraController();
  }

  // Add this method back to your class
  Future<XFile?> _compressImageIfNeeded(XFile imageFile) async {
    try {
      final File file = File(imageFile.path);
      final int fileSize = await file.length();

      // Maximum file size (5MB)
      const int maxFileSizeInBytes = 5 * 1024 * 1024;

      // If file is already under 5MB, return as is
      if (fileSize <= maxFileSizeInBytes) {
        return imageFile;
      }

      // Compress the image
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        format: CompressFormat.jpeg,
      );

      return compressedFile ?? imageFile;
    } catch (e) {
      debugPrint('Compression error: $e');
      // Return original file if compression fails
      return imageFile;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _safeDispose();
    super.dispose();
  }

  // ✅ NEW: guard — only disposes if initialize() actually completed
  Future<void> _safeDispose() async {
    if (_isInitialized && controller != null) {
      _isInitialized = false;
      await controller!.dispose();
      controller = null;
    } else {
      // initialize() is still in flight or never started — just null the ref
      // The controller will be GC'd; CameraX won't crash because the
      // surface texture was never handed to Flutter's render tree
      controller = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _safeDispose();
      if (mounted) setState(() => initialized = false);
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(selectedCameraIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: publicAppBar(
        context,
        "cameraScreenTitle".tr(),
      ),
      body: initialized && controller != null // Add null check
          ? Stack(
              children: [
                SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Platform.isIOS
                      ? CameraPreview(controller!)
                      : RotatedBox(
                          quarterTurns: 0,
                          // quarterTurns: cameras[selectedCameraIndex].lensDirection == CameraLensDirection.front ? 0 : 0,
                          child: AspectRatio(
                            aspectRatio: controller!.value.aspectRatio,
                            child: CameraPreview(controller!),
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Switch Camera Button
                        if (cameras.length > 1)
                          FloatingActionButton(
                            heroTag: 'switchCamera',
                            backgroundColor: navBarBackground,
                            onPressed: initialized ? _switchCamera : null,
                            child: const Icon(
                              Icons.flip_camera_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                        // Take Picture Button
                        FloatingActionButton(
                          heroTag: 'takePhoto',
                          backgroundColor: navBarBackground,
                          onPressed: isTakingPicture
                              ? null
                              : () async {
                                  setState(() {
                                    isTakingPicture = true;
                                  });

                                  try {
                                    final XFile capturedFile =
                                        await controller!.takePicture();

                                    // Compress if needed
                                    final XFile? finalFile =
                                        await _compressImageIfNeeded(
                                            capturedFile);

                                    if (!context.mounted) return;
                                    Navigator.pop(
                                        context, finalFile ?? capturedFile);
                                  } catch (e) {
                                    _handleCameraError(e,
                                        message: "photoCaptureFailed".tr());
                                  } finally {
                                    setState(() {
                                      isTakingPicture = false;
                                    });
                                  }
                                },
                          child: isTakingPicture
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Icon(Icons.camera, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text("cameraLoading".tr(),
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
    );
  }
}



//
// import 'dart:io';
//
// import 'package:app/core/helpers/extensions.dart';
// import 'package:camera/camera.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
//
// import '../../../../core/theming/colors.dart';
// import '../../../../core/widgets/public_appbar.dart';
//
// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key});
//
//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
//   CameraController? controller; // Make nullable
//   bool initialized = false;
//   bool isTakingPicture = false;
//   List<CameraDescription> cameras = [];
//   int selectedCameraIndex = 0;
//
//   Future<void> _initializeCameraController([int? cameraIndex]) async {
//     try {
//       // Get available cameras if not already fetched
//       if (cameras.isEmpty) {
//         cameras = await availableCameras();
//       }
//       if (cameras.isEmpty) {
//         throw CameraException('noCameras', 'No cameras available');
//       }
//       // Use provided index or default to front camera
//       if (cameraIndex != null) {
//         selectedCameraIndex = cameraIndex;
//       } else {
//         selectedCameraIndex = cameras.indexWhere(
//           (camera) => camera.lensDirection == CameraLensDirection.front,
//         );
//         if (selectedCameraIndex == -1) selectedCameraIndex = 0;
//       }
//
//       // Dispose previous controller if exists
//       if (controller != null) {
//         await controller!.dispose();
//         controller = null;
//       }
//
//       // Reset initialized flag
//       if (mounted) {
//         setState(() {
//           initialized = false;
//         });
//       }
//
//       // Create and initialize new controller
//       controller = CameraController(
//         cameras[selectedCameraIndex],
//         ResolutionPreset.high,
//       );
//
//       await controller!.initialize();
//       //await controller!.lockCaptureOrientation(DeviceOrientation.);
//       if (!mounted) {
//         await controller?.dispose();
//         return;
//       }
//
//       setState(() {
//         initialized = true;
//       });
//     } catch (e) {
//       _handleCameraError(e, message: "cameraInitFailed".tr());
//     }
//   }
//
//   void _switchCamera() async {
//     setState(() {
//       initialized = false;
//     });
//
//     final nextIndex = (selectedCameraIndex + 1) % cameras.length;
//     await _initializeCameraController(nextIndex);
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final CameraController? cameraController = controller;
//
//     // App state changed before we got the chance to initialize.
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return;
//     }
//
//     if (state == AppLifecycleState.inactive) {
//       cameraController.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _initializeCameraController(selectedCameraIndex);
//     }
//   }
//
//   void _handleCameraError(Object error, {String? message}) {
//     final errorMessage = message ?? "unexpectedError".tr();
//     context.showErrorToast(errorMessage);
//     debugPrint('Camera Error: $error');
//   }
//
//   // Add this method back to your class
//   Future<XFile?> _compressImageIfNeeded(XFile imageFile) async {
//     try {
//       final File file = File(imageFile.path);
//       final int fileSize = await file.length();
//
//       // Maximum file size (5MB)
//       const int maxFileSizeInBytes = 5 * 1024 * 1024;
//
//       // If file is already under 5MB, return as is
//       if (fileSize <= maxFileSizeInBytes) {
//         return imageFile;
//       }
//
//       // Compress the image
//       final dir = await getTemporaryDirectory();
//       final targetPath = path.join(
//         dir.path,
//         'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
//       );
//
//       final compressedFile = await FlutterImageCompress.compressAndGetFile(
//         file.absolute.path,
//         targetPath,
//         quality: 85,
//         format: CompressFormat.jpeg,
//       );
//
//       return compressedFile ?? imageFile;
//     } catch (e) {
//       debugPrint('Compression error: $e');
//       // Return original file if compression fails
//       return imageFile;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeCameraController();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     controller?.dispose(); // Safe disposal with null check
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: publicAppBar(
//         context,
//         "cameraScreenTitle".tr(),
//       ),
//       body: initialized && controller != null && controller!.value.isInitialized
//           ? Stack(
//               children: [
//                 SizedBox(
//                   height: double.maxFinite,
//                   width: double.maxFinite,
//                   child: Platform.isIOS
//                       ? CameraPreview(controller!)
//                       : RotatedBox(
//                           quarterTurns: 0,
//                           // quarterTurns: cameras[selectedCameraIndex].lensDirection == CameraLensDirection.front ? 0 : 0,
//                           child: AspectRatio(
//                             aspectRatio: controller!.value.aspectRatio,
//                             child: CameraPreview(controller!),
//                           ),
//                         ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 32.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         // Switch Camera Button
//                         if (cameras.length > 1)
//                           FloatingActionButton(
//                             heroTag: 'switchCamera',
//                             backgroundColor: navBarBackground,
//                             onPressed: initialized ? _switchCamera : null,
//                             child: const Icon(
//                               Icons.flip_camera_ios_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         // Take Picture Button
//                         FloatingActionButton(
//                           heroTag: 'takePhoto',
//                           backgroundColor: navBarBackground,
//                           onPressed: isTakingPicture
//                               ? null
//                               : () async {
//                                   setState(() {
//                                     isTakingPicture = true;
//                                   });
//
//                                   try {
//                                     final XFile capturedFile =
//                                         await controller!.takePicture();
//
//                                     // Compress if needed
//                                     final XFile? finalFile =
//                                         await _compressImageIfNeeded(
//                                             capturedFile);
//
//                                     if (!context.mounted) return;
//                                     Navigator.pop(
//                                         context, finalFile ?? capturedFile);
//                                   } catch (e) {
//                                     _handleCameraError(e,
//                                         message: "photoCaptureFailed".tr());
//                                   } finally {
//                                     if (mounted) {
//                                       setState(() {
//                                         isTakingPicture = false;
//                                       });
//                                     }
//                                   }
//                                 },
//                           child: isTakingPicture
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white)
//                               : const Icon(Icons.camera, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircularProgressIndicator(),
//                   const SizedBox(height: 20),
//                   Text("cameraLoading".tr(),
//                       style: const TextStyle(fontSize: 16)),
//                 ],
//               ),
//             ),
//     );
//   }
// }
//
//
//
//
