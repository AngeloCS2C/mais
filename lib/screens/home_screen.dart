// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart'; // System sound support
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // For background color picker
import 'package:file_saver/file_saver.dart'; // Save images to gallery
import '../services/camera_service.dart'; // Camera handling logic
import '../services/ml_service.dart'; // Machine learning inference logic
import '../data/disease_info.dart'; // Disease data
import '../screens/recommendationpage.dart'; // Navigate to recommendations

var logger = Logger();

class HomeScreen extends StatefulWidget {
  final CameraService? cameraService;

  const HomeScreen({
    super.key,
    required this.cameraService,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late MLService _mlService;
  File? imageFile;
  bool isFlashOn = false;
  String buttonText = 'IDENTIFY';
  bool showResultBox = false;
  String resultText = 'Result:';
  bool showOpenResultButton = false;
  bool showIdentifyingModal = false;
  bool _isCameraInitialized = false;

  // Custom settings
  String currentLanguage = 'en';
  Color backgroundColor = const Color(0xFFE7EE43); // Default background color
  double fontSize = 16; // Adjustable font size
  bool autoSavePhoto = true;

  @override
  void initState() {
    super.initState();
    _mlService = MLService();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _mlService.loadModels();
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameraService != null) {
      await widget.cameraService!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } else {
      logger.e("CameraService not initialized.");
    }
  }

  @override
  void dispose() {
    widget.cameraService?.dispose();
    _mlService.dispose();
    super.dispose();
  }

  void _playClickSound() {
    SystemSound.play(SystemSoundType.click);
  }

  Future<void> _saveToGallery(String imagePath) async {
    final file = File(imagePath);
    final fileName = file.path.split('/').last;
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: await file.readAsBytes(),
      ext: "jpg",
      mimeType: MimeType.jpeg,
    );
    logger.i("Image saved to gallery: $fileName");
  }

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
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'tl', child: Text('Tagalog')),
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
                    // Color picker
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
                                  onPressed: () => Navigator.of(context).pop(),
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
                    // Placeholder toggle for sound effects
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
    final cameraBoxHeight = screenSize.height * 0.85;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Ma-Iscanner',
          style: TextStyle(color: Colors.black, fontSize: fontSize),
        ),
        centerTitle: true,
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                _buildCameraBox(cameraBoxHeight),
                // Flash toggle
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
                        _playClickSound();
                      },
                    ),
                  ),
                // Action buttons
                if (!showOpenResultButton && !showResultBox)
                  Positioned(
                    bottom: 7,
                    left: 15,
                    right: 15,
                    child: _buildActionButtons(),
                  ),
                // Open Result button
                if (showOpenResultButton)
                  Positioned(
                    bottom: 100,
                    left: MediaQuery.of(context).size.width * 0.25,
                    right: MediaQuery.of(context).size.width * 0.25,
                    child: _buildOpenResultButton(),
                  ),
                // Result box
                if (showResultBox) _buildResultBox(),
                // Delete button
                if (imageFile != null && showResultBox)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.redAccent, size: 40),
                      onPressed: () async {
                        setState(() {
                          imageFile = null;
                          showResultBox = false;
                          showOpenResultButton = false;
                          buttonText = 'IDENTIFY';
                        });
                        await _restartCamera();
                      },
                    ),
                  ),
                // Identifying modal
                if (showIdentifyingModal) _buildIdentifyingModal(),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

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
            ? Image.file(imageFile!, fit: BoxFit.cover)
            : (widget.cameraService!.controller.value.isInitialized
                ? CameraPreview(widget.cameraService!.controller)
                : Container()),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.68),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleActionButton(
            icon: Icons.settings,
            label: '',
            onPressed: _openSettingsModal,
          ),
          _buildCircleActionButton(
            icon: Icons.search,
            label: buttonText,
            onPressed: () async {
              _playClickSound();
              if (imageFile == null) await captureImage();
              await classifyImage();
            },
          ),
          _buildCircleActionButton(
            icon: Icons.upload,
            label: '',
            onPressed: uploadImage,
          ),
        ],
      ),
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
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ],
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

  Widget _buildOpenResultButton() {
    return ElevatedButton(
      onPressed: _openResultPage,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black.withOpacity(0.43),
        elevation: 6.2,
      ),
      child: const Text('OPEN RESULT', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildIdentifyingModal() {
    return Center(
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
    );
  }

  Future<void> captureImage() async {
    final capturedFile = await widget.cameraService!.captureImage();
    if (capturedFile != null) {
      setState(() {
        imageFile = File(capturedFile.path);
        showIdentifyingModal = true;
        widget.cameraService!.controller.pausePreview();
      });
      if (autoSavePhoto) await _saveToGallery(capturedFile.path);
      await classifyImage();
    } else {
      logger.e("Capture failed: No file returned.");
    }
  }

  Future<void> classifyImage() async {
    if (imageFile != null) {
      await _mlService.classifyImage(imageFile!.path).then((result) {
        setState(() {
          resultText = result;
          showResultBox = true;
          showOpenResultButton = true;
          showIdentifyingModal = false;
        });
      });
    } else {
      logger.e("Classification failed: No image file.");
    }
  }

  Future<void> uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        showIdentifyingModal = false;
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

    // Corrected diseaseKey extraction
    String diseaseKey =
        resultText.split(':').last.trim().toLowerCase().replaceAll(' ', '_');
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
            fontSize: fontSize,
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
