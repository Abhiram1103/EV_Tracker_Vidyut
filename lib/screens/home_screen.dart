import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> classes = const [
    {
      'title': 'Vaahan 1',
      'image': 'assets/images/ev1.png',
    },
    {
      'title': 'Vaahan 2',
      'image': 'assets/images/ev2.png',
    },
    {
      'title': 'Vaahan 3',
      'image': 'assets/images/ev3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'My EVs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Image.asset(
              'assets/images/top_icon.png',
              height: screenWidth * 0.15,
              width: screenWidth * 0.15,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 187, 235, 250),
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 251, 237, 228),
              Color.fromARGB(255, 209, 226, 252),
            ],
          ),
        ),
        child: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.04),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final item = classes[index];
                return GestureDetector(
                  onTap: () {
                    if (item['title'] == 'Vaahan 1') {
                      Navigator.pushNamed(context, '/map');
                    }
                  },
                  child: CourseCard(
                    title: item['title'] as String,
                    imagePath: item['image'] as String,
                    colorIndex: index,
                  ),
                );
              },
            ),
            Positioned(
              bottom: screenHeight * 0.01,
              left: 0,
              right: 0,
              child: const Center(child: ImageCarousel()),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final int colorIndex;

  const CourseCard({
    required this.title,
    required this.imagePath,
    required this.colorIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.02,
      ),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      child: Container(
        height: screenHeight * 0.16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color.fromARGB(255, 209, 226, 252),
              Color.fromARGB(
                255,
                (137 + (colorIndex * 20)).clamp(137, 255),
                245,
                255,
              ),
              Color.fromARGB(
                255,
                (50 + (colorIndex * 10)).clamp(50, 255),
                109,
                168,
              ),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Image.asset(
                imagePath,
                height: screenWidth * 0.3,
                width: screenWidth * 0.3,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.ev_station, size: screenWidth * 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<String> imagePaths = const [
    'assets/images/bottom1.png',
    'assets/images/bottom2.png',
    'assets/images/bottom3.png',
    'assets/images/bottom4.png',
  ];

  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
  timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
    setState(() {
      currentIndex = (currentIndex + 1) % imagePaths.length;
    });
  });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Image.asset(
        imagePaths[currentIndex],
        key: ValueKey<String>(imagePaths[currentIndex]),
        height: screenHeight * 0.35,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, size: screenHeight * 0.2),
      ),
    );
  }
}