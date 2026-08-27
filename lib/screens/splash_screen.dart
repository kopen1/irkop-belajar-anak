import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/maskot.dart';

/// Splash — logo Irkop Kids 2 detik -> fade ke Home (PRD B.3)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
          ),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Maskot(emoji: '⭐', size: 96),
            const SizedBox(height: 12),
            Text('Belajar Anak',
                    style: GoogleFonts.nunito(fontSize: 44, fontWeight: FontWeight.w800, color: Colors.white))
                .animate()
                .fadeIn(duration: 600.ms),
            const SizedBox(height: 6),
            Text('Bermain Sambil Belajar 🎈',
                    style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white70))
                .animate(delay: 300.ms)
                .fadeIn(duration: 600.ms),
          ]),
        ),
      ),
    );
  }
}
