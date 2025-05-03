
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<User?> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Login error: \$e");
      return null;
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
