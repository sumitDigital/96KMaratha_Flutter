import 'package:flutter/material.dart';

class MeetVerticallyScreen extends StatefulWidget {
  const MeetVerticallyScreen({super.key});

  @override
  _MeetVerticallyScreenState createState() => _MeetVerticallyScreenState();
}

class _MeetVerticallyScreenState extends State<MeetVerticallyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topImageAnimation;
  late Animation<double> _bottomImageAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Screen dimensions for animation calculation
    final screenHeight =
        MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;
    final screenWidth =
        MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

    // Define animations for both images
    _topImageAnimation = Tween<double>(
      begin: -200.0, // Start beyond the top edge
      end: screenHeight / 2 - 50, // Center the top image
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _bottomImageAnimation = Tween<double>(
      begin: screenHeight + 200.0, // Start beyond the bottom edge
      end: screenHeight / 2 +
          75, // Position the bottom image directly below the top image
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          // Top Image
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _topImageAnimation.value, // Animate vertically
                left: screenWidth / 2 - 100, // Horizontal center
                child: child!,
              );
            },
            child: Image.asset(
              "assets/homelogo.png",
              width: 200,
              height: 150,
            ),
          ),
          // Bottom Image
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _bottomImageAnimation.value, // Animate vertically
                left: screenWidth / 2 - 100, // Horizontal center
                child: child!,
              );
            },
            child: Image.asset(
              fit: BoxFit.cover,
              "assets/logoname.png",
              width: 200,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
