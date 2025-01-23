import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding1');
    });

    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 2),
          curve: Curves.bounceOut, // Applying bounce effect
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value, // Scale the image based on the tween value
              child: Image.asset(
                'assets/images/logo-pikam.png',
                height: 100,
              ),
            );
          },
        ),
      ),
    );
  }
}
