import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import '../services/camera_service.dart';
import '../screens/start_screen.dart'; // Path to the StartScreen

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
    _navigateToStartScreen(); // Navigate to StartScreen after initialization
  }

  // Navigate to StartScreen
  Future<void> _navigateToStartScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartScreen(cameraService: _cameraService),
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
            child: Image.asset(
              'assets/MaiscannerLogo.png',
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 90),
            child: LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
