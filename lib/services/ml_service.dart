import 'dart:typed_data';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

var logger = Logger();

class MLService {
  Interpreter? _classifierInterpreter;
  Interpreter? _detectorInterpreter;
  List<String> _classifierLabels = [];
  List<String> _detectorLabels = [];

  Future<void> loadModels() async {
    try {
      // Load the main classifier model
      _classifierInterpreter =
          await Interpreter.fromAsset('assets/corn.tflite');
      _classifierLabels = await _loadLabels('assets/labels.txt');
      logger.i("Classifier model and labels loaded successfully.");

      // Load the object detector model
      _detectorInterpreter = await Interpreter.fromAsset(
          'assets/Object_Detector/maisDetector.tflite');
      _detectorLabels = await _loadLabels('assets/Object_Detector/labels.txt');
      logger.i("Object detector model and labels loaded successfully.");
    } catch (e) {
      logger.e("Failed to load models or labels: $e");
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

  Future<bool> detectCornLeaf(String imagePath) async {
    try {
      logger.i("Running object detection for corn leaf...");

      // Load the image
      Uint8List imageBytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        logger.e("Image decoding failed for detection.");
        return false;
      }

      // Resize the image for the model
      img.Image resizedImage = img.copyResize(image, width: 256, height: 256);

      // Prepare the input tensor
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

      if (_detectorInterpreter == null) {
        logger.e("Object detector interpreter is not initialized.");
        return false;
      }

      // Run inference
      var output =
          List.generate(1, (_) => List.filled(_detectorLabels.length, 0.0));
      _detectorInterpreter!.run(reshapedInput, output);

      // Log and interpret the result
      var probabilities = output[0];
      logger.i("Object detection probabilities: $probabilities");

      final maxProbabilityIndex = probabilities.indexWhere((element) =>
          element == probabilities.reduce((a, b) => a > b ? a : b));

      if (maxProbabilityIndex >= 0 &&
          maxProbabilityIndex < _detectorLabels.length) {
        final result = _detectorLabels[maxProbabilityIndex].trim();
        logger.i("Detected object: $result");

        return result == "corn_leaf";
      } else {
        logger.e("Object detection output index out of bounds.");
        return false;
      }
    } catch (e) {
      logger.e("Error during object detection: $e");
      return false;
    }
  }

  Future<String> classifyImage(String imagePath) async {
    try {
      logger.i("Starting image classification...");

      // Run object detection first
      final isCornLeaf = await detectCornLeaf(imagePath);
      logger.i("Corn leaf detection result: $isCornLeaf");

      if (!isCornLeaf) {
        logger.w("Image rejected: No corn leaf detected.");
        return "No corn leaf detected. Classification aborted.";
      }

      logger.i("Corn leaf detected. Proceeding to disease classification...");

      // Load and preprocess the image
      Uint8List imageBytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        logger.e("Image decoding failed.");
        return "Error decoding image.";
      }

      img.Image resizedImage = img.copyResize(image, width: 256, height: 256);

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

      if (_classifierInterpreter == null) {
        logger.e("Classifier interpreter is not initialized.");
        return "Model not loaded.";
      }

      var output =
          List.generate(1, (_) => List.filled(_classifierLabels.length, 0.0));
      _classifierInterpreter!.run(reshapedInput, output);

      var probabilities = output[0];
      logger.i("Classification probabilities: $probabilities");

      final maxProbabilityIndex = probabilities.indexWhere((element) =>
          element == probabilities.reduce((a, b) => a > b ? a : b));

      if (maxProbabilityIndex >= 0 &&
          maxProbabilityIndex < _classifierLabels.length) {
        var result = _classifierLabels[maxProbabilityIndex].trim();

        // Remove leading underscore if it exists
        if (result.startsWith('_')) {
          result = result.substring(1);
        }

        logger.i("Normalized disease classification result: $result");
        return 'Disease: $result';
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
    _classifierInterpreter?.close();
    _detectorInterpreter?.close();
  }
}
