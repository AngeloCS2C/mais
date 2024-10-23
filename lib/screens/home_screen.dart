// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart'; // For default system sounds
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Color picker
import 'package:file_saver/file_saver.dart'; // For saving to gallery
import '../services/camera_service.dart'; // Camera logic
import '../services/ml_service.dart'; // Machine learning logic
import '../data/disease_info.dart'; // Importing DiseaseInfo
import '../screens/recommendationpage.dart'; // Importing RecommendationPage

var logger = Logger();

class HomeScreen extends StatefulWidget {
  final CameraService? cameraService; // Receive the initialized CameraService
  const HomeScreen({
    super.key,
    required this.cameraService,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late MLService _mlService;
  File? imageFile; // Handle both camera and uploaded images
  bool isFlashOn = false; // Flash is off by default
  String buttonText = 'IDENTIFY'; // "IDENTIFY" is the main function
  bool showResultBox = false; // Control the result box visibility
  String resultText = 'Result:';
  bool showOpenResultButton =
      false; // Controls showing the "Open Result" button
  bool showIdentifyingModal =
      false; // Controls the identifying modal visibility
  bool _isCameraInitialized = false; // Track whether the camera is initialized

  // Custom additions
  String currentLanguage = 'en'; // Track current language for toggling
  Color backgroundColor =
      const Color(0xFFE7EE43); // Default background color (Yellow)
  double fontSize = 16; // Default font size
  bool autoSavePhoto = true; // Auto-save photo feature

  @override
  void initState() {
    super.initState();
    _mlService = MLService();
    _mlService.loadModel();
    _initializeCamera(); // Automatically start the camera
  }

  Future<void> _initializeCamera() async {
    if (widget.cameraService != null) {
      setState(() {
        _isCameraInitialized = true; // Camera is initialized
      });
    } else {
      logger.e("CameraService not initialized");
    }
  }

  @override
  void dispose() {
    widget.cameraService?.dispose(); // Dispose of the camera when done
    _mlService.dispose();
    super.dispose();
  }

  // Play system click sound when buttons are pressed
  void _playClickSound() {
    SystemSound.play(SystemSoundType.click);
  }

  // Save the captured image to the gallery if auto-save is enabled
  Future<void> _saveToGallery(String imagePath) async {
    final file = File(imagePath);
    final fileName =
        file.path.split('/').last; // Extract the file name from the path

    // Correct the use of named arguments for saving the file
    await FileSaver.instance.saveFile(
      name: fileName, // The file name (use the 'name' argument)
      bytes: await file
          .readAsBytes(), // The file content (use the 'bytes' argument)
      ext: "jpg", // The file extension (use the 'ext' argument)
      mimeType: MimeType.jpeg, // Specify the correct MIME type
    );

    logger.i("Image saved to gallery: $fileName");
  }

  // Open the settings modal with options for language, background color, etc.
  void _openSettingsModal() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Settings'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Language dropdown
                    ListTile(
                      title: const Text('Set Language'),
                      subtitle: DropdownButton<String>(
                        value: currentLanguage,
                        items: const [
                          DropdownMenuItem(
                            value: 'en',
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: 'tl',
                            child: Text('Tagalog'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            currentLanguage = value!;
                            buttonText = currentLanguage == 'en'
                                ? 'IDENTIFY'
                                : 'TUKUYIN';
                          });
                        },
                      ),
                    ),

                    // Color picker for background
                    const Text('Pick Background Color'),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Select Color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: backgroundColor,
                                  onColorChanged: (color) {
                                    setState(() {
                                      backgroundColor = color;
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('DONE'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                      ),
                      child: const Text('Pick a Color'),
                    ),

                    // Auto-save toggle
                    ListTile(
                      title: const Text('Auto Save Photo'),
                      trailing: Switch(
                        value: autoSavePhoto,
                        onChanged: (value) {
                          setState(() {
                            autoSavePhoto = value;
                          });
                        },
                      ),
                    ),

                    // Sound effects toggle (dummy toggle for now)
                    ListTile(
                      title: const Text('Sound Effects'),
                      trailing: Switch(value: true, onChanged: (val) {}),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CLOSE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cameraBoxHeight = screenSize.height * 0.85; // Fill most of the screen

    return Scaffold(
      backgroundColor: backgroundColor, // Use dynamic background color
      appBar: AppBar(
        backgroundColor: backgroundColor, // Sync with dynamic background
        elevation: 0,
        title: Text('Ma-Iscanner',
            style: TextStyle(
                color: Colors.black, fontSize: fontSize)), // Font size applied
        centerTitle: true,
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                // Camera Preview filling most of the screen
                _buildCameraBox(cameraBoxHeight),

                // Flash button positioned at the top-right of the camera preview
                if (widget.cameraService!.controller.value.isInitialized &&
                    imageFile == null)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: Icon(
                        isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.yellow,
                        size: 40,
                      ),
                      onPressed: () {
                        toggleFlash();
                        _playClickSound(); // Play sound on click
                      },
                    ),
                  ),

                // Bottom imaginary box for the action buttons (Settings, Identify, Upload)
                if (!showOpenResultButton && !showResultBox)
                  Positioned(
                    bottom: 7,
                    left: 15,
                    right: 15,
                    child: Container(
                      width: screenSize.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.68),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Settings button with opacity
                          _buildCircleActionButtonWithOpacity(
                            icon: Icons.settings,
                            label: '',
                            onPressed: () {
                              _openSettingsModal();
                              _playClickSound(); // Play sound on click
                            },
                            opacity: 0.8,
                          ),
                          // Identify button (for capturing and classifying the image)
                          _buildCircleActionButton(
                            icon: Icons.search,
                            label: buttonText, // Shows dynamic text
                            onPressed: () async {
                              _playClickSound(); // Play sound on click
                              if (imageFile == null) {
                                await captureImage(); // Capture image if none is selected
                              }
                              await classifyImage(); // Classify the image
                            },
                          ),
                          // Upload button with opacity
                          _buildCircleActionButtonWithOpacity(
                            icon: Icons.upload,
                            label: '',
                            onPressed: () {
                              uploadImage();
                              _playClickSound(); // Play sound on click
                            },
                            opacity: 0.8,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Open Result button appears after identification
                if (showOpenResultButton)
                  Positioned(
                    bottom: 100,
                    left: MediaQuery.of(context).size.width * 0.25,
                    right: MediaQuery.of(context).size.width * 0.25,
                    child: _buildOpenResultButton(),
                  ),

                // Result box for classification result
                if (showResultBox) _buildResultBox(),

                // Delete button appears when the result is shown
                if (imageFile != null && showResultBox)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.redAccent, size: 40),
                      onPressed: () async {
                        setState(() {
                          imageFile = null; // Remove the image
                          showResultBox = false; // Hide the result box
                          showOpenResultButton =
                              false; // Hide the open result button
                          buttonText = 'IDENTIFY'; // Reset the button text
                        });
                        await _restartCamera(); // Restart the camera when the image is deleted
                      },
                    ),
                  ),

                // Identifying modal
                if (showIdentifyingModal)
                  Center(
                    child: Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Identifying...',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child:
                  CircularProgressIndicator(), // Show progress indicator while camera is initializing
            ),
    );
  }

  // Build camera box with dynamic image or preview
  Widget _buildCameraBox(double height) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: imageFile != null
            ? _buildCapturedImage(height)
            : (widget.cameraService!.controller.value.isInitialized
                ? _buildCameraPreview()
                : Container()), // Show live camera feed if no image
      ),
    );
  }

  Widget _buildCameraPreview() {
    return CameraPreview(widget.cameraService!.controller);
  }

  Widget _buildCapturedImage(double height) {
    return Image.file(
      imageFile!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
    );
  }

  Widget _buildResultBox() {
    return Positioned(
      bottom: 200,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          resultText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleActionButtonWithOpacity({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required double opacity,
  }) {
    return Column(
      children: [
        Opacity(
          opacity: opacity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.3),
              elevation: 6,
            ),
            child: Icon(icon, size: 30, color: Colors.green),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.3),
            elevation: 6,
          ),
          child: Icon(icon, size: 30, color: Colors.green),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildOpenResultButton() {
    return ElevatedButton(
      onPressed: _openResultPage,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        fixedSize: const Size(230, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black.withOpacity(0.43),
        elevation: 6.2,
      ),
      child: const Text('OPEN RESULT', style: TextStyle(fontSize: 18)),
    );
  }

  Future<void> captureImage() async {
    final capturedFile = await widget.cameraService!.captureImage();
    if (capturedFile != null) {
      setState(() {
        imageFile = File(capturedFile.path);
        showIdentifyingModal = true; // Show identifying modal
        widget.cameraService!.controller.pausePreview(); // Pause preview
      });
      if (autoSavePhoto) {
        await _saveToGallery(capturedFile.path); // Auto-save to gallery
      }
      await classifyImage();
    } else {
      logger.e("Capture failed: No file returned.");
    }
  }

  Future<void> classifyImage() async {
    if (imageFile != null) {
      await _mlService.classifyImage(imageFile!.path).then((result) {
        setState(() {
          resultText = result; // Update result text
          showResultBox = true; // Show result box
          showOpenResultButton = true; // Show Open Result button
          showIdentifyingModal = false; // Hide identifying modal
        });
      });
    } else {
      logger.e("Classification failed: No image file.");
    }
  }

  Future<void> uploadImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        showIdentifyingModal = false; // Do not classify immediately
      });
    }
  }

  Future<void> _restartCamera() async {
    setState(() {
      showIdentifyingModal = false;
    });
    widget.cameraService!.dispose();
    await widget.cameraService!.initialize();
    setState(() {});
  }

  void _openResultPage() {
    if (imageFile == null) {
      logger.e("No image to show in result page.");
      return;
    }

    String diseaseKey = resultText
        .replaceFirst('Result: ', '')
        .trim()
        .toLowerCase()
        .replaceAll(' ', '_');
    bool isHealthy = diseaseKey == 'healthy';

    if (isHealthy || DiseaseInfo.treatmentDetails.containsKey(diseaseKey)) {
      Map<String, dynamic>? diseaseDetails =
          isHealthy ? null : DiseaseInfo.treatmentDetails[diseaseKey];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationPage(
            disease:
                isHealthy ? 'Healthy Leaf' : diseaseKey.replaceAll('_', ' '),
            details: diseaseDetails,
            imagePath: imageFile!.path,
            isHealthy: isHealthy,
            fontSize: fontSize, // Pass font size to the recommendation page
          ),
        ),
      ).then((_) {
        _restartCamera();
      });
    } else {
      logger.e('Disease key not found: $diseaseKey');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Disease information not found.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void toggleFlash() async {
    await widget.cameraService!.toggleFlash(!isFlashOn);
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }
}
