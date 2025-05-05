import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/map_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vidyut',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        RouteObserver<ModalRoute<void>>(), // Added navigation observer
      ],
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}