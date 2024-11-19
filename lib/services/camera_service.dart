import 'package:camera/camera.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class CameraService {
  CameraController? _controller;
  final CameraDescription camera;

  CameraService(this.camera);

  Future<void> initialize() async {
    _controller =
        CameraController(camera, ResolutionPreset.high, enableAudio: false);
    try {
      await _controller!.initialize();
      logger.i('Camera initialized');
    } catch (e) {
      logger.e('Error initializing camera: $e');
    }
  }

  // Start image streaming with a provided callback
  void startImageStream(Function(CameraImage) onAvailable) {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.startImageStream(onAvailable);
      logger.i('Camera image stream started');
    }
  }

  // Stop image streaming
  void stopImageStream() {
    if (_controller != null && _controller!.value.isStreamingImages) {
      _controller!.stopImageStream();
      logger.i('Camera image stream stopped');
    }
  }

  Future<XFile?> captureImage() async {
    try {
      return await _controller?.takePicture();
    } catch (e) {
      logger.e('Error capturing image: $e');
      return null;
    }
  }

  Future<void> toggleFlash(bool isFlashOn) async {
    try {
      await _controller
          ?.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
    } catch (e) {
      logger.e('Error toggling flash: $e');
    }
  }

  CameraController get controller => _controller!;

  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
      logger.i('Camera controller disposed');
    }
  }
}
