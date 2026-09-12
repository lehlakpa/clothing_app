import 'package:flutter/material.dart';

class LogoShowScreen extends StatefulWidget {
  const LogoShowScreen({super.key});

  @override
  State<LogoShowScreen> createState() => _LogoShowScreenState();
}

class _LogoShowScreenState extends State<LogoShowScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
