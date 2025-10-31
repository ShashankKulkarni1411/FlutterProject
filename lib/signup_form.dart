import 'package:flutter/material.dart';
import 'auth_main.dart';
import 'screens/dashboard_screen.dart';
import 'app_logo.dart';

class SignUpForm extends StatefulWidget {
  final Function(bool) onToggleTab;
  
  const SignUpForm({super.key, required this.onToggleTab});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;

  void handleSignup() async {
    if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);
    String res = await AuthService.signup(nameCtrl.text, emailCtrl.text, passCtrl.text);
    setState(() => loading = false);

    if (res.contains("success")) {
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
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggleTab(false),
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
                        "Sign Up",
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
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Full Name Label
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 2),
            child: Text(
              "Full Name",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
        ),
        // Full Name TextField
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C3D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: nameCtrl,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline, color: Colors.grey[500], size: 20),
              hintText: "John Doe",
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),

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
            keyboardType: TextInputType.emailAddress,
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
        const SizedBox(height: 28),

        // Sign Up Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: loading ? null : handleSignup,
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
                    "Create Account",
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
}