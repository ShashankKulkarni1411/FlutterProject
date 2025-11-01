import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'app_logo.dart';
import 'app_title.dart';
import 'page_indicator.dart';
import 'auth_main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Stack(
        children: [
          // Animated bubbles and squares background
          const AnimatedBackground(),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                AppLogo(),
                SizedBox(height: 20),
                AppTitle(),
                SizedBox(height: 30),
                PageIndicator(currentIndex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  final List<FloatingShape> shapes = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    // Create multiple floating shapes
    _createShapes();
  }

  void _createShapes() {
    // Create 8-12 shapes
    final shapeCount = 10;
    for (int i = 0; i < shapeCount; i++) {
      shapes.add(FloatingShape(
        key: ValueKey(i),
        isCircle: random.nextBool(),
        size: random.nextDouble() * 60 + 40, // 40-100
        duration: random.nextInt(10) + 15, // 15-25 seconds
        startX: random.nextDouble(),
        startY: random.nextDouble(),
        endX: random.nextDouble(),
        endY: random.nextDouble(),
        opacity: random.nextDouble() * 0.3 + 0.1, // 0.1-0.4
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: shapes,
    );
  }
}

class FloatingShape extends StatefulWidget {
  final bool isCircle;
  final double size;
  final int duration;
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double opacity;

  const FloatingShape({
    super.key,
    required this.isCircle,
    required this.size,
    required this.duration,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.opacity,
  });

  @override
  State<FloatingShape> createState() => _FloatingShapeState();
}

class _FloatingShapeState extends State<FloatingShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _animationX = Tween<double>(
      begin: widget.startX,
      end: widget.endX,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _animationY = Tween<double>(
      begin: widget.startY,
      end: widget.endY,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _animationX.value * screenWidth - widget.size / 2,
          top: _animationY.value * screenHeight - widget.size / 2,
          child: Transform.rotate(
            angle: widget.isCircle ? 0 : _rotationAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F).withOpacity(widget.opacity),
                shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius:
                    widget.isCircle ? null : BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}