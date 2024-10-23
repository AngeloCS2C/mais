import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // For default system sounds

class RecommendationPage extends StatefulWidget {
  final String disease;
  final String imagePath;
  final Map<String, dynamic>? details;
  final bool isHealthy;
  final double fontSize; // Font size passed from HomeScreen

  const RecommendationPage({
    super.key,
    required this.disease,
    required this.details,
    required this.imagePath,
    required this.isHealthy,
    required this.fontSize,
  });

  @override
  RecommendationPageState createState() => RecommendationPageState();
}

class RecommendationPageState extends State<RecommendationPage> {
  String currentLanguage = 'en'; // Track current language
  double currentFontSize = 16; // Track current font size
  String fontSizeLabel = "Medium"; // Label for font size

  @override
  void initState() {
    super.initState();
    currentFontSize = widget.fontSize; // Initialize with passed font size
  }

  // Play system click sound when buttons are pressed
  void _playClickSound() {
    SystemSound.play(SystemSoundType.click);
  }

  // Toggle language between English and Tagalog
  void toggleLanguage() {
    setState(() {
      currentLanguage = currentLanguage == 'en' ? 'tl' : 'en';
    });
  }

  // Cycle through font sizes (small, medium, large, extra large)
  void toggleFontSize() {
    setState(() {
      if (currentFontSize == 12) {
        currentFontSize = 16;
        fontSizeLabel = "Medium";
      } else if (currentFontSize == 16) {
        currentFontSize = 20;
        fontSizeLabel = "Large";
      } else if (currentFontSize == 20) {
        currentFontSize = 24;
        fontSizeLabel = "Extra Large";
      } else {
        currentFontSize = 12;
        fontSizeLabel = "Small";
      }
    });
  }

  // Show recommendations modal dialog with images for each tip
  void showRecommendationsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF5F5DC), // Light beige background
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/plant_tips.png', // Example image asset
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // Title with a yellow background and green shadow
                const Text(
                  'Plant Tips',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50), // Green color
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Color(0xFFE7E713), // Yellow shadow
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Scrollable recommendations with images and green scrollbar
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(10),
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: ListView.builder(
                      itemCount: widget
                          .details!['recommendations'][currentLanguage].length,
                      itemBuilder: (context, index) {
                        final recommendation =
                            widget.details!['recommendations'][currentLanguage]
                                [index];
                        final recommendationText =
                            recommendation['text'] as String;
                        final imagePath = recommendation['image'] as String;
                        final explanation =
                            recommendation['explanation'] as String;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  imagePath,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                recommendationText,
                                style: TextStyle(
                                  fontSize: currentFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                explanation,
                                style: TextStyle(
                                  fontSize: currentFontSize - 2,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _playClickSound(); // Play sound on click
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF4CAF50), // Matching green
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.details;

    // Healthy leaf messages in English and Tagalog
    final healthyMessage = {
      'en': 'Your leaf is healthy. Thank you for using Ma-Isanner!',
      'tl': 'Ang iyong dahon ay malusog. Salamat sa paggamit ng Ma-Isanner!',
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE7E713), // Yellow background
        elevation: 0,
        title: const Text('Ma-iscanner', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _playClickSound(); // Play sound on click
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFE7E713), // Entire page yellow
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'KantumruyPro-Regular',
            color: Colors.black87,
            fontSize: currentFontSize, // Apply dynamic font size
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(widget.imagePath),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Display Disease Name with font size adjustment beside it
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFF388E3C), width: 1),
                    ),
                    child: Text(
                      widget.disease.toUpperCase(),
                      style: TextStyle(
                        fontSize: currentFontSize + 4,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Font size adjustment with label beside the disease name
                  ElevatedButton.icon(
                    onPressed: () {
                      _playClickSound(); // Play sound on click
                      toggleFontSize(); // Cycle through font sizes
                    },
                    icon: const Icon(Icons.text_fields, size: 20),
                    label: Text(fontSizeLabel),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // If the leaf is healthy, display a healthy message and allow language switching
              if (widget.isHealthy)
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _playClickSound(); // Play sound on click
                          toggleLanguage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          currentLanguage == 'en'
                              ? 'SWITCH TO TAGALOG'
                              : 'SWITCH TO ENGLISH',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          healthyMessage[currentLanguage]!,
                          style: TextStyle(
                            fontSize: currentFontSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'SCIENTIFIC NAME',
                                style: TextStyle(
                                    fontFamily: 'KantumruyPro-Bold',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _playClickSound(); // Play sound on click
                                  toggleLanguage();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  currentLanguage == 'en'
                                      ? 'SWITCH TO TAGALOG'
                                      : 'SWITCH TO ENGLISH',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details!['scientificName'][currentLanguage] ??
                                'N/A',
                            style: TextStyle(
                                fontFamily: 'KantumruyPro-MediumItalic',
                                fontSize: currentFontSize - 2,
                                color: const Color.fromARGB(221, 58, 55, 55)),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'DESCRIPTION:',
                            style: TextStyle(
                                fontFamily: 'KantumruyPro-Bold',
                                fontSize: 18,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details['description'][currentLanguage] ?? 'N/A',
                            style: TextStyle(
                                fontSize: currentFontSize,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'EFFECTS:',
                            style: TextStyle(
                                fontFamily: 'KantumruyPro-Bold',
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details['effects'][currentLanguage] ?? 'N/A',
                            style: TextStyle(
                                fontSize: currentFontSize,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              if (!widget.isHealthy)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _playClickSound(); // Play sound on click
                      showRecommendationsModal(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'CHECK PLANT TIPS',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
