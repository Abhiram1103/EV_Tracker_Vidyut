//import 'package:app1/gradient_container.dart';
import 'package:flutter/material.dart';

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

class HomeScreen extends StatelessWidget {
    HomeScreen({super.key}); 
  final List<Map<String, dynamic>> classes = [
    {'title': 'Vahan 1' , 'image': 'assets/images/ev1.png',},
    {'title': 'Vahan 2' , 'image': 'assets/images/ev1.png',},
    {'title': 'Vahan 3' ,'image': 'assets/images/ev1.png',},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
  backgroundColor: Color.fromARGB(255, 243, 248, 190),
  elevation: 4,
  ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 251, 237, 228),
              Color.fromARGB(255, 255, 235, 176),
           
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
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/bottom_ev1.png',
                  height: 270,
                  fit: BoxFit.contain,
                ),
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
  Color.fromARGB(255, 137 + (colorIndex * 20), 245, 255), // Darker variant
  Color.fromARGB(255, 50 + (colorIndex * 30), 109, 168), // Custom ARGB

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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8),
 
                  ],
                ),
              ),
              SizedBox(width: 20),
              Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
