import 'package:flutter/material.dart';

class MeetInCenterScreen extends StatefulWidget {
  const MeetInCenterScreen({super.key});

  @override
  _MeetInCenterScreenState createState() => _MeetInCenterScreenState();
}

class _MeetInCenterScreenState extends State<MeetInCenterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _leftImageAnimation;
  late Animation<double> _rightImageAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Screen dimensions for animation calculation
    final screenWidth =
        MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

    // Define animations for both images
    _leftImageAnimation = Tween<double>(
      begin: -200.0, // Start beyond the left edge
      end: screenWidth / 2 - 100, // Center horizontally for Image 1
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _rightImageAnimation = Tween<double>(
      begin: screenWidth + 200.0, // Start beyond the right edge
      end: screenWidth / 2 - 100, // Center horizontally for Image 2
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          // Left Image
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: screenHeight / 2 - 100, // Vertical center
                left: _leftImageAnimation.value, // Animate horizontally
                child: child!,
              );
            },
            child: Image.asset(
              'assets/homelogo.png', // Replace with your image
              width: 200,
              height: 200,
            ),
          ),
          // Right Image
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: screenHeight / 2 - 100, // Vertical center
                left: _rightImageAnimation.value, // Animate horizontally
                child: child!,
              );
            },
            child: Image.asset(
              'assets/homelogo.png', // Replace with your image
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
