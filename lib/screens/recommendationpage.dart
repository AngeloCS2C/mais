import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // For default system sounds

class RecommendationPage extends StatefulWidget {
  final String disease;
  final String imagePath;
  final Map<String, dynamic>? details;
  final bool isHealthy;
  final double fontSize;

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
  String currentLanguage = 'en';
  double currentFontSize = 16;
  String fontSizeLabel = "Medium";

  @override
  void initState() {
    super.initState();
    currentFontSize = widget.fontSize;
  }

  void _playClickSound() {
    SystemSound.play(SystemSoundType.click);
  }

  void toggleLanguage() {
    setState(() {
      currentLanguage = currentLanguage == 'en'
          ? 'tl'
          : 'en'; // Switch between English and Tagalog
    });
  }

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

  void showRecommendationsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF5F5DC),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/plant_tips.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Plant Tips',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Color(0xFFE7E713),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(10),
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: ListView.builder(
                      itemCount:
                          widget.details!['plant_tips'][currentLanguage].length,
                      itemBuilder: (context, index) {
                        final recommendation = widget.details!['plant_tips']
                            [currentLanguage][index];
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _playClickSound();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
    final healthyMessage = {
      'en': 'Your leaf is healthy. Thank you for using Ma-Isanner!',
      'tl': 'Ang iyong dahon ay malusog. Salamat sa paggamit ng Ma-Isanner!',
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE7E713),
        elevation: 0,
        title: const Text('Ma-iscanner', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _playClickSound();
              toggleFontSize();
            },
            icon: const Icon(Icons.text_fields, color: Colors.black),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _playClickSound();
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFE7E713),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'KantumruyPro-Regular',
            color: Colors.black87,
            fontSize: currentFontSize,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Result Box with fixed font size
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
                      style: const TextStyle(
                        fontSize: 20, // Fixed font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _playClickSound();
                      toggleLanguage();
                    },
                    icon: const Icon(Icons.language, size: 20),
                    label:
                        Text(currentLanguage == 'en' ? 'Tagalog' : 'English'),
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
              widget.isHealthy
                  ? Expanded(
                      child: Center(
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
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SCIENTIFIC NAME',
                              style: TextStyle(
                                fontSize: currentFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4), // Added spacing
                            Text(
                              details!['scientificName'][currentLanguage] ??
                                  'N/A',
                              style: TextStyle(
                                fontSize: currentFontSize,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16), // Added spacing
                            Text(
                              'DESCRIPTION',
                              style: TextStyle(
                                fontSize: currentFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4), // Added spacing
                            Text(
                              details['description'][currentLanguage] ?? 'N/A',
                              style: TextStyle(
                                fontSize: currentFontSize,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              if (!widget.isHealthy)
                SizedBox(
                  width:
                      double.infinity, // This line makes the button full width
                  child: ElevatedButton(
                    onPressed: () {
                      _playClickSound();
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
