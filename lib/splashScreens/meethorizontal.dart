import 'dart:async';
import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class RotatingImage extends StatefulWidget {
  const RotatingImage({super.key});

  @override
  _RotatingImageState createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage>
    with TickerProviderStateMixin {
  double _rotation = 0.0;
  Timer? _timer;
  late AnimationController _controller;
  late AnimationController _controller1;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();
    _startRotation();

    // Animation controller for heartbeat and sliding the image
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Heartbeat duration
      vsync: this,
    )..repeat(reverse: true); // Repeats the heartbeat animation

    _heartbeatAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Animation for sliding the static image from the right
    _controller1 = AnimationController(
      duration: const Duration(seconds: 1), // Duration of the slide
      vsync: this,
    )..forward(); // Play the animation only once

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );
  }

  void _startRotation() {
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        _rotation += 0.05;
        if (_rotation >= 360) {
          _rotation = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rotating logo with heartbeat animation
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: ScaleTransition(
                scale:
                    _heartbeatAnimation, // Scale transition applied to the CircleAvatar
                child: Container(
                  alignment: Alignment.center, // Ensures proper alignment
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.rotationY(
                            _rotation), // Rotating transition for the image
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    child: Image.asset(
                      "assets/logodesign.png",
                      height: 200,
                      width: 150,
                    ),
                  ),
                ),
              ),
            ),
            // Static image sliding from the right side of the screen
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Image.asset(
                  'assets/logoname.png',
                  fit: BoxFit.cover,
                  height: 110,
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
