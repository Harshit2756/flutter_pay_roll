import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pay_roll/shared/widgets/background.dart';
import 'package:pay_roll/ui/attendance/submit_form.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/permission_handler.dart';

class CameraUI extends StatefulWidget {
  final bool isEntry;
  const CameraUI({super.key, required this.isEntry});

  @override
  State<CameraUI> createState() => _CameraUIState();
}

class _CameraUIState extends State<CameraUI> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isFrontCamera = false;
  bool _isTorchOn = false;
  bool _hasCameraPermission = false;
  final PermissionHandlerService _permissionService =
      PermissionHandlerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (kIsWeb)
              const Center(
                child: BackgroundContainer(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'Click the camera button below to capture an image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            else if (_controller?.value.isInitialized ?? false)
              Center(
                child: BackgroundContainer(
                  padding: const EdgeInsets.all(30),
                  child: CameraPreview(_controller!),
                ),
              ),

            // Bottom controls
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!kIsWeb) ...[
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios),
                      color: Colors.white,
                      iconSize: 32,
                      onPressed: () async {
                        setState(() {
                          _isFrontCamera = !_isFrontCamera;
                        });
                        _controller = CameraController(
                          _cameras[_isFrontCamera ? 1 : 0],
                          ResolutionPreset.high,
                          enableAudio: false,
                        );
                        await _controller!.initialize();
                        if (mounted) setState(() {});
                      },
                    ),
                  ],

                  // Capture button
                  FloatingActionButton(
                    onPressed: kIsWeb ? _takeWebPicture : _takePicture,
                    backgroundColor: Colors.white,
                    child:
                        const Icon(Icons.camera, color: Colors.black, size: 32),
                  ),

                  // Torch button (only show for rear camera)
                  if (!kIsWeb) ...[
                    IconButton(
                      icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off),
                      color: _isFrontCamera ? Colors.grey : Colors.white,
                      iconSize: 32,
                      onPressed: _isFrontCamera
                          ? null
                          : () async {
                              setState(() {
                                _isTorchOn = !_isTorchOn;
                              });
                              await _controller?.setFlashMode(
                                  _isTorchOn ? FlashMode.torch : FlashMode.off);
                            },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeCamera();
    }
  }

  Future<void> _checkAndRequestCameraPermission() async {
    bool hasPermission = await _permissionService.handleCameraPermission();
    setState(() {
      _hasCameraPermission = hasPermission;
    });
    if (hasPermission) {
      // _showPermissionStatus('Camera permission is allowed');
    } else {
      _showPermissionStatus('Camera permission is not allowed');
      await _requestCameraPermission();
    }
  }

  Future<void> _initializeCamera() async {
    await _checkAndRequestCameraPermission();
    if (_hasCameraPermission) {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras[_isFrontCamera ? 1 : 0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _hasCameraPermission = true;
      });
      _showPermissionStatus('Camera permission granted');
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog();
    } else {
      _showPermissionStatus('Camera permission denied');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera Permission Required'),
          content: const Text(
              'This app needs camera access to take pictures. Please grant camera permission in settings to continue.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous screen
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _permissionService.openAppSettings();
                await _checkAndRequestCameraPermission(); // Check again after returning from settings
              },
            ),
          ],
        );
      },
    );
  }

  void _showPermissionStatus(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _takePicture() async {
    if (!_hasCameraPermission ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _controller!.takePicture();
      if (mounted) {
        // Pass both photo and isEntry to SubmitForm
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SubmitForm(
              photo: photo,
              isEntry: widget.isEntry,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking picture: $e')),
        );
      }
    }
  }

  Future<void> _takeWebPicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      if (image != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SubmitForm(
              photo: image,
              isEntry: widget.isEntry,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    }
  }

}
