import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_services.dart';
import '../services/api_services.dart';

class LogoutDialog extends StatelessWidget {
  final Color accentColor;
  final BuildContext parentContext;

  const LogoutDialog({
    super.key,
    required this.accentColor,
    required this.parentContext,
  });

  Future<void> _performLogout() async {
    try {
      // Close any active connections
      await ApiService.dispose();
      
      // Perform Firebase logout
      await FirebaseAuth.instance.signOut();
      
      // Clear local authentication state
      await AuthService.logout();

      // Navigate back to login screen
      Navigator.of(parentContext).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirm Logout',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: Text(
        'Are you sure you want to sign out?',
        style: GoogleFonts.poppins(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(); // Dismiss dialog
            await _performLogout();      // Then perform logout
          },
          child: Text(
            "Logout",
            style: GoogleFonts.poppins(
              color: accentColor,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}

// Usage from any screen:
void showLogoutDialog(BuildContext context, Color accentColor) {
  showDialog(
    context: context,
    builder: (context) => LogoutDialog(
      accentColor: accentColor,
      parentContext: context,
    ),
  );
}