import 'dart:typed_data';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

var logger = Logger();

class MLService {
  Interpreter? _interpreter;
  List<String> _labels = [];

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/corn.tflite');
      _labels = await _loadLabels('assets/labels.txt');
      logger.i("Model and labels loaded successfully.");
    } catch (e) {
      logger.e("Failed to load model or labels: $e");
    }
  }

  Future<List<String>> _loadLabels(String filePath) async {
    try {
      final labelsData = await rootBundle.loadString(filePath);
      return labelsData.split('\n').where((label) => label.isNotEmpty).toList();
    } catch (e) {
      logger.e("Error loading labels: $e");
      return [];
    }
  }

  List<List<List<List<double>>>> _reshape(
      List<double> input, int batch, int height, int width, int channels) {
    return List.generate(batch, (b) {
      return List.generate(height, (h) {
        return List.generate(width, (w) {
          return List.generate(channels, (c) {
            return input[(b * height * width * channels) +
                (h * width * channels) +
                (w * channels) +
                c];
          });
        });
      });
    });
  }

  Future<String> classifyImage(String imagePath) async {
    try {
      logger.i("Starting classification");

      Uint8List imageBytes = await File(imagePath).readAsBytes();
      logger.i("Image loaded");

      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        logger.e("Image decoding failed.");
        return "Error decoding image.";
      }

      img.Image resizedImage = img.copyResize(image, width: 256, height: 256);
      logger.i("Image resized");

      var input = List.generate(1 * 256 * 256 * 3, (i) => 0.0);
      int pixelIndex = 0;

      for (int y = 0; y < 256; y++) {
        for (int x = 0; x < 256; x++) {
          var pixel = resizedImage.getPixel(x, y);
          input[pixelIndex++] = img.getRed(pixel) / 255.0;
          input[pixelIndex++] = img.getGreen(pixel) / 255.0;
          input[pixelIndex++] = img.getBlue(pixel) / 255.0;
        }
      }

      var reshapedInput = _reshape(input, 1, 256, 256, 3);
      logger.i("Image preprocessing completed");

      if (_interpreter == null) {
        logger.e("Interpreter is not initialized.");
        return "Model not loaded.";
      }

      var output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
      logger.i("Running inference");

      _interpreter!.run(reshapedInput, output);
      logger.i("Inference completed");

      var probabilities = output[0];
      final maxProbabilityIndex = probabilities.indexWhere((element) =>
          element == probabilities.reduce((a, b) => a > b ? a : b));

      if (maxProbabilityIndex >= 0 && maxProbabilityIndex < _labels.length) {
        return 'Result: ${_labels[maxProbabilityIndex]}';
      } else {
        logger.e("Output index out of bounds for labels.");
        return "Classification failed.";
      }
    } catch (e) {
      logger.e("Error classifying image: $e");
      return "Error occurred during classification.";
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
