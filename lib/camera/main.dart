import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

CameraController? _controller;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras[0];

  runApp(CameraApp(camera: firstCamera));
}

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({super.key, required this.camera});

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _controller?.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Camera App')),
          body: Stack(
            children: [
              CameraPreview(_controller!),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    await _controller?.takePicture();
                  },
                  child: const Icon(Icons.camera),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
