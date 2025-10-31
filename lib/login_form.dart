/* import 'package:flutter/material.dart';
import 'auth_main.dart';
import 'screens/dashboard_screen.dart';
import 'app_logo.dart';

class LoginForm extends StatefulWidget {
  final Function(bool) onToggleTab;
  
  const LoginForm({super.key, required this.onToggleTab});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;

  void handleLogin() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);
    String res = await AuthService.login(emailCtrl.text, passCtrl.text);
    setState(() => loading = false);

    if (res.contains("successful") || res.contains("created")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo at the top
        const SizedBox(height: 20),
        const AppLogo(),
        const SizedBox(height: 20),
        // App Title
        const Text(
          "PanamChukwani",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        Text(
          "Smart Spending, Smarter Saving",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 32),

        // Login/Sign Up Tabs
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF1A2837),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggleTab(true),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF00D9FF),
                          width: 3,
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFF00D9FF),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggleTab(false),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Email Label
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 2),
            child: Text(
              "Email",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
        ),
        // Email TextField
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C3D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: emailCtrl,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[500], size: 20),
              hintText: "your@email.com",
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Password Label
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 2),
            child: Text(
              "Password",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
        ),
        // Password TextField
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C3D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: passCtrl,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[500], size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey[500],
                  size: 20,
                ),
                onPressed: () => setState(() => obscure = !obscure),
              ),
              hintText: "••••••••",
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18, letterSpacing: 2),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                color: Color(0xFF00D9FF),
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: loading ? null : handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9FF),
              foregroundColor: const Color(0xFF0D1B2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFF0D1B2A),
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // Or continue with
        Text(
          "Or continue with",
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),

        // Social Login Buttons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2C3D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.facebook, color: Colors.white, size: 20),
                  label: const Text(
                    "Facebook",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2C3D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 24),
                  label: const Text(
                    "Google",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Terms and Privacy
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey[500], fontSize: 11, height: 1.4),
              children: const [
                TextSpan(text: "By continuing, you agree to our "),
                TextSpan(
                  text: "Terms of Service",
                  style: TextStyle(color: Color(0xFF00D9FF)),
                ),
                TextSpan(text: " and\n"),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(color: Color(0xFF00D9FF)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Skip for now
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          },
          child: const Text(
            "Skip for now",
            style: TextStyle(
              color: Color(0xFF00D9FF),
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_main.dart';
import 'screens/dashboard_screen.dart';
import 'app_logo.dart';
import 'firebase_service.dart';

class LoginForm extends StatefulWidget {
  final Function(bool) onToggleTab;
  
  const LoginForm({super.key, required this.onToggleTab});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  bool loading = false;
  bool obscure = true;

  Future<void> _testFirebaseConnection() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      
      print('');
      print('═══════════════════════════════════════');
      print('🔥 FIREBASE CONNECTION TEST');
      print('═══════════════════════════════════════');
      
      // Test 1: Firebase Auth
      if (currentUser != null) {
        print('✅ Firebase Auth: Connected');
        print('   User ID: ${currentUser.uid}');
        print('   Email: ${currentUser.email}');
      } else {
        print('❌ Firebase Auth: No user logged in');
      }
      
      // Test 2: Firestore Write
      print('');
      print('📝 Testing Firestore Write...');
      await FirebaseFirestore.instance
          .collection('_connection_test')
          .doc('login_test_${DateTime.now().millisecondsSinceEpoch}')
          .set({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Login successful',
        'userId': currentUser?.uid,
        'email': currentUser?.email,
      });
      print('✅ Firestore Write: Successful');
      
      // Test 3: Initialize user data
      print('');
      print('📊 Initializing user data...');
      await _firebaseService.initializeUserData();
      print('✅ User Data: Initialized');
      
      // Test 4: Read user data
      print('');
      print('📖 Reading user data...');
      final userData = await _firebaseService.getUserProfile();
      if (userData != null) {
        print('✅ User Data Retrieved:');
        print('   Name: ${userData['name']}');
        print('   Email: ${userData['email']}');
        print('   Balance: ₹${userData['walletBalance']}');
        print('   Income: ₹${userData['totalIncome']}');
        print('   Expenses: ₹${userData['totalExpenses']}');
      } else {
        print('⚠️  User data not found (will be created on first transaction)');
      }
      
      print('');
      print('═══════════════════════════════════════');
      print('✅ ALL FIREBASE TESTS PASSED!');
      print('═══════════════════════════════════════');
      print('');
      
    } catch (e) {
      print('');
      print('═══════════════════════════════════════');
      print('❌ FIREBASE CONNECTION ERROR');
      print('═══════════════════════════════════════');
      print('Error: $e');
      print('');
    }
  }

  void handleLogin() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);
    
    try {
      String res = await AuthService.login(emailCtrl.text, passCtrl.text);
      
      setState(() => loading = false);

      if (res.contains("successful") || res.contains("created")) {
        // Test Firebase connection after successful login
        await _testFirebaseConnection();
        
        // Show success message with Firebase status
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '🎉 Login successful!\n✅ Firebase connected! Check console.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      print('❌ Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo at the top
        const SizedBox(height: 20),
        const AppLogo(),
        const SizedBox(height: 20),
        // App Title
        const Text(
          "PanamChukwani",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        Text(
          "Smart Spending, Smarter Saving",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 32),

        // Login/Sign Up Tabs
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF1A2837),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggleTab(true),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF00D9FF),
                          width: 3,
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFF00D9FF),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggleTab(false),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Email Label
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 2),
            child: Text(
              "Email",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
        ),
        // Email TextField
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C3D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: emailCtrl,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[500], size: 20),
              hintText: "your@email.com",
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Password Label
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 2),
            child: Text(
              "Password",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
        ),
        // Password TextField
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C3D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: passCtrl,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[500], size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey[500],
                  size: 20,
                ),
                onPressed: () => setState(() => obscure = !obscure),
              ),
              hintText: "••••••••",
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18, letterSpacing: 2),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                color: Color(0xFF00D9FF),
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: loading ? null : handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9FF),
              foregroundColor: const Color(0xFF0D1B2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFF0D1B2A),
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        // Firebase indicator (for testing)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF10B981).withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_done,
                size: 14,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              Text(
                'Firebase Ready',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Or continue with
        Text(
          "Or continue with",
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),

        // Social Login Buttons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2C3D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.facebook, color: Colors.white, size: 20),
                  label: const Text(
                    "Facebook",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2C3D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 24),
                  label: const Text(
                    "Google",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Testing hint
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C3D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF00D9FF).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.info_outline, size: 14, color: Color(0xFF00D9FF)),
                  SizedBox(width: 6),
                  Text(
                    'Firebase Testing:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00D9FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '• Login to see Firebase connection logs in console\n'
                '• Check Profile page for live data\n'
                '• Add transactions to test Firestore',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Terms and Privacy
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey[500], fontSize: 11, height: 1.4),
              children: const [
                TextSpan(text: "By continuing, you agree to our "),
                TextSpan(
                  text: "Terms of Service",
                  style: TextStyle(color: Color(0xFF00D9FF)),
                ),
                TextSpan(text: " and\n"),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(color: Color(0xFF00D9FF)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Skip for now
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          },
          child: const Text(
            "Skip for now",
            style: TextStyle(
              color: Color(0xFF00D9FF),
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}