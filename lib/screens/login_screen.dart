import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  void _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // ✅ Input validation
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Email and password cannot be empty';
        _loading = false;
      });
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // ✅ Navigate to home only if login is successful
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'An unexpected error occurred');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005bFF);
    const accentColor = Color(0xFF7FB2FF);

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
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign in to continue',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // ✅ Error display
                if (_error != null) ...[
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
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: primaryColor),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility_outlined,
                          color: Colors.grey),
                      onPressed: () {}, // Optional: Add toggle logic
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: _loading
                      ? const Center(
                          child:
                              CircularProgressIndicator(color: primaryColor))
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 6,
                            shadowColor: accentColor,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // ✅ Signup Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "         New User?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/Signup');
                      },
                      child: const Text(
                        'Create Account    ',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const SizedBox(height: 190),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ Helper: Typewriter Text Widget (no changes needed)
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
  _TypewriterCyclingTextState createState() => _TypewriterCyclingTextState();
}

class _TypewriterCyclingTextState extends State<TypewriterCyclingText> {
  late String _currentText;
  int _charIndex = 0;
  int _wordIndex = 0;
  Timer? _typingTimer;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _currentText = '';
    _startTyping();
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(widget.speed, (timer) {
      if (_charIndex < widget.words[_wordIndex].length) {
        setState(() {
          _currentText += widget.words[_wordIndex][_charIndex];
          _charIndex++;
        });
      } else {
        _typingTimer?.cancel();
        _delayTimer = Timer(const Duration(seconds: 3), () {
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
    _delayTimer?.cancel();
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
            style: widget.style.copyWith(
              color: const Color(0xFF005bFF),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '|',
            style: widget.style.copyWith(
              color: (_currentText.length ==
                      widget.words[_wordIndex].length)
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