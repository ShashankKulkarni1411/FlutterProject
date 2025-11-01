import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  void toggleTab(bool login) => setState(() => isLogin = login);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            // Animated Form
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey<bool>(isLogin),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isLogin 
                    ? LoginForm(onToggleTab: toggleTab) 
                    : SignUpForm(onToggleTab: toggleTab),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Signup
  static Future<String> signup(String name, String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _db.collection('users').doc(userCred.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now(),
      });

      return "Account created successfully!";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Signup failed.";
    }
  }

  // Login
  static Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Login successful!";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed.";
    }
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }
}

class AuthTabSwitch extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const AuthTabSwitch({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: isLogin ? null : onToggle,
          child: Column(
            children: [
              Text(
                "Login",
                style: TextStyle(
                  color: isLogin ? Colors.cyanAccent : Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isLogin)
                Container(
                  height: 2,
                  width: 50,
                  margin: const EdgeInsets.only(top: 4),
                  color: Colors.cyanAccent,
                ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        GestureDetector(
          onTap: isLogin ? onToggle : null,
          child: Column(
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                  color: !isLogin ? Colors.cyanAccent : Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isLogin)
                Container(
                  height: 2,
                  width: 60,
                  margin: const EdgeInsets.only(top: 4),
                  color: Colors.cyanAccent,
                ),
            ],
          ),
        ),
      ],
    );
  }
}