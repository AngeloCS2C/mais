import 'package:flutter_test/flutter_test.dart';
// Import your app
import 'package:camera/camera.dart';
import 'package:ma_iscanner_1/main.dart'; // Import camera

void main() {
  testWidgets('HomeScreen test', (WidgetTester tester) async {
    // Initialize the camera for testing
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // Build the HomeScreen with the required camera parameter
    await tester.pumpWidget(MyApp(camera: firstCamera));

    // Add your widget testing code here...
  });
}
