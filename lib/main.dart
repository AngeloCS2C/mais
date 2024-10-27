import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'splash_screen.dart'; // Ensure the correct path to SplashScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get available cameras
  final cameras = await availableCameras();
  final firstCamera = cameras.isNotEmpty ? cameras.first : null;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription? camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ma Iscanner',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(camera: camera), // Pass camera to SplashScreen
    );
  }
}
