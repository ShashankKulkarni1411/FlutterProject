import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("Or continue with", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _socialBtn(Icons.facebook, "Facebook"),
            _socialBtn(Icons.g_mobiledata, "Google"),
          ],
        ),
      ],
    );
  }

  Widget _socialBtn(IconData icon, String text) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white10,
        foregroundColor: Colors.white,
        minimumSize: const Size(140, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, size: 24),
      label: Text(text),
    );
  }
}
