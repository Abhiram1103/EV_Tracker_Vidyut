import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import for FirebaseAuthException
import 'dart:async'; // Import for Timer
import 'package:ev_tracker_app/services/auth_services.dart';
import 'package:ev_tracker_app/models/user.dart' as app_user;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Removed unused _auth field
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isRegistering = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  final primaryColor = const Color(0xFF005bFF);
  final accentColor = const Color(0xFF7FB2FF);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (_isRegistering && value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (_isRegistering && (value == null || value.isEmpty)) {
      return 'Name is required';
    }
    return null;
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _isRegistering
          ? await AuthService.registerUser(
              _nameController.text,
              _emailController.text,
              _passwordController.text,
            )
          : await AuthService.loginUser(
              _emailController.text,
              _passwordController.text,
            );

      if (user != null && mounted) {
        AuthService.currentUser = app_user.User.fromFirebaseUser(user);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Authentication failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleFormMode() {
    setState(() {
      _isRegistering = !_isRegistering;
      _errorMessage = null;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFE6F0FF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Column(
                    children: [
                      const SizedBox(height: 80),
                      TypewriterCyclingText(
                        words: const ['Vidhyut', 'विद्युत', 'విద్యుత్'],
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        speed: const Duration(milliseconds: 100),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isRegistering
                            ? 'Create new account'
                            : 'Sign in to continue',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  if (_errorMessage != null) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(_errorMessage!,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (_isRegistering)
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outline,
                            color: Color(0xFF005bFF)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF005bFF), width: 2),
                        ),
                      ),
                      validator: _validateName,
                      textCapitalization: TextCapitalization.words,
                    ),
                  if (_isRegistering) const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined,
                          color: Color(0xFF005bFF)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF005bFF), width: 2),
                      ),
                    ),
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Color(0xFF005bFF)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF005bFF), width: 2),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  if (_isRegistering) const SizedBox(height: 20),
                  if (_isRegistering)
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF005bFF)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off),
                          onPressed: () => setState(
                              () => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF005bFF), width: 2),
                        ),
                      ),
                      validator: _validateConfirmPassword,
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Color(0xFF005bFF)))
                        : ElevatedButton(
                            onPressed: _handleAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 6,
                              shadowColor: accentColor,
                            ),
                            child: Text(_isRegistering ? 'Create Account' : 'Sign In'),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_isRegistering
                          ? 'Already have an account? '
                          : 'Don\'t have an account? '),
                      TextButton(
                        onPressed: _toggleFormMode,
                        child: Text(
                          _isRegistering ? 'Sign In' : 'Sign Up',
                          style: const TextStyle(color: Color(0xFF005bFF)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TypewriterCyclingText extends StatefulWidget {
  final List<String> words;
  final TextStyle style;
  final Duration speed;

  const TypewriterCyclingText({
    super.key,
    required this.words,
    required this.style,
    this.speed = const Duration(milliseconds: 100),
  });

  @override
  State<TypewriterCyclingText> createState() => _TypewriterCyclingTextState();
}

class _TypewriterCyclingTextState extends State<TypewriterCyclingText> {
  late String _currentText;
  int _charIndex = 0;
  int _wordIndex = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _currentText = '';
    _startTyping();
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(widget.speed, (timer) {
      if (_charIndex < widget.words[_wordIndex].length) {
        setState(() => _currentText += widget.words[_wordIndex][_charIndex++]);
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _wordIndex = (_wordIndex + 1) % widget.words.length;
            _charIndex = 0;
            _currentText = '';
            _startTyping();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Welcome to '),
          TextSpan(
            text: _currentText,
            style: widget.style.copyWith(color: const Color(0xFF005bFF)),
          ),
          TextSpan(
            text: '|',
            style: widget.style.copyWith(
              color: (_currentText.length == widget.words[_wordIndex].length)
                  ? Colors.transparent
                  : const Color(0xFF005bFF),
            ),
          ),
        ],
      ),
      style: widget.style,
    );
  }
}