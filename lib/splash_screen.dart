import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import '../services/camera_service.dart';
import 'screens/home_screen.dart'; // Ensure the correct path to HomeScreen

var logger = Logger();

class SplashScreen extends StatefulWidget {
  final CameraDescription? camera; // Camera description passed from main.dart
  const SplashScreen({super.key, required this.camera});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  CameraService? _cameraService;

  @override
  void initState() {
    super.initState();
    _initializeCameraService(); // Initialize camera during splash screen
    _navigateToHome(); // Navigate to home screen after splash
  }

  // Initialize CameraService during the splash screen
  Future<void> _initializeCameraService() async {
    if (widget.camera != null) {
      _cameraService = CameraService(widget.camera!);
      await _cameraService!.initialize(); // Initialize the camera
      logger.i('Camera initialized during splash screen');
    } else {
      logger.e('No camera found during splash screen initialization');
    }
  }

  // Navigate to HomeScreen after splash
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3)); // 3-second splash delay

    if (!mounted) return;

    // Navigate to HomeScreen and pass CameraService
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(cameraService: _cameraService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/MaiscannerLogo.png',
                width: 150, height: 150),
          ),
          const SizedBox(height: 20), // Add space between logo and loading bar
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 90), // Control width of loading bar
            child:
                LinearProgressIndicator(), // Loading bar instead of circular progress
          ),
        ],
      ),
    );
  }
}
