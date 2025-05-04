//import 'package:app1/gradient_container.dart';
import 'dart:async'; // Add this line with other imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
void main() => runApp(ClassroomApp());

class ClassroomApp extends StatelessWidget {
    const ClassroomApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduClasfafs',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({Key? key}) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<String> imagePaths = [
    'assets/images/bottom1.png',
    'assets/images/bottom3.png',
    'assets/images/bottom2.png',
    'assets/images/bottom4.png',
   // 'assets/images/ev1.png',

  ];

  int currentIndex = 0;
  Timer? timer; // Changed from late to nullable

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Safe cancel with null check
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Image.asset(
        imagePaths[currentIndex],
        key: ValueKey<String>(imagePaths[currentIndex]),
        height: 320,
        fit: BoxFit.contain,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
    HomeScreen({super.key}); 
  final List<Map<String, dynamic>> classes = [
    {'title': 'Vahaan 1' , 'image': 'assets/images/ev1.png',},
    {'title': 'Vaahan 2' , 'image': 'assets/images/ev2.png',},
    {'title': 'Vaahan 3' ,'image': 'assets/images/ev3.png',},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 81, 224, 76),
      appBar: AppBar(  title: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'My EVs',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      SizedBox(width: 8),
      Image.asset(
        'assets/images/top_icon.png', // Replace with your actual image path
        height: 100,
        width: 100,
      ),
    ],
  ),
  centerTitle: true,
  backgroundColor: Color.fromARGB(255, 254, 158, 158),
  elevation: 4,
  ),
      body: Container(
        decoration: BoxDecoration(
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
              padding: EdgeInsets.all(16),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                return CourseCard(
                  title: classes[index]['title'],
                 // code: classes[index]['code'],
                  imagePath: classes[index]['image'],
                  colorIndex: index,
                );
              },
            ),

            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: const Center(
                child: ImageCarousel(),
                 // 'assets/images/bottom1.png',
                  //height: 400,
                  //fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  //final String code;
  final String imagePath;
  final int colorIndex;

  const CourseCard({
    required this.title,
    //required this.code,
    required this.imagePath,
    required this.colorIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 209, 226, 252),
              
  Color.fromARGB(255, 137 + (colorIndex * 20), 245, 255), // Darker variant
  Color.fromARGB(255, 50 + (colorIndex * 10), 109, 168), // Custom ARGB

],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
              SizedBox(width: 50), // sizebox of Vahan
              Image.asset(
                imagePath,
                height: 170,
                width: 170,
                fit: BoxFit.cover,// changedfrom fit to cover
              ),
            ],
          ),
        ),
      ),
    );
  }
}
