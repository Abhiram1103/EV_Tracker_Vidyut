import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../config/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;
  bool _showCursor = true;

  Future<void> _login() async {
    if (!mounted) return;
    
    // Validate fields
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _getErrorMessage(e.code));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Login failed. Please try again';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF005bFF);
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
                _buildHeader(),
                const SizedBox(height: 40),
                if (_error != null) _buildErrorCard(),
                _buildEmailField(blue),
                const SizedBox(height: 20),
                _buildPasswordField(blue),
                const SizedBox(height: 24),
                _buildLoginButton(blue, accentColor),
                _buildSignupRedirect(blue),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 80),
        const TypewriterCyclingText(
          words: ['Vidhyut', 'विद्युत', 'విద్యుత్'],
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          speed: Duration(milliseconds: 100),
        ),
        const SizedBox(height: 10),
        Text(
          'Sign in to continue',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard() {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
    );
  }

  Widget _buildEmailField(Color blue) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField(Color blue) {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword 
                ? Icons.visibility_off_outlined 
                : Icons.visibility_outlined,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget _buildLoginButton(Color blue, Color accentColor) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
    );
  }

  Widget _buildSignupRedirect(Color blue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            child: Text(
              'Create Account',
              style: TextStyle(
                color: blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Typewriter Effect Widget with Improved Animation
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
  Timer? _delayTimer;
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();
    _currentText = '';
    _startTyping();
    _startCursorBlink();
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
        _delayTimer = Timer(const Duration(seconds: 2), () {
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

  void _startCursorBlink() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() => _showCursor = !_showCursor);
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
            text: _showCursor && _currentText.length < widget.words[_wordIndex].length
                ? '|'
                : '',
            style: widget.style.copyWith(
              color: const Color(0xFF005bFF),
            ),
          ),
        ],
      ),
      style: widget.style,
    );
  }
}