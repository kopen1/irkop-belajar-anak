import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';
import 'maskot.dart';

/// Layar hasil kuis — bintang 1-3 muncul satu-satu + konfeti (PRD B.2.5, C.4)
class HasilKuis extends StatefulWidget {
  final int score;
  final int total;
  final String kategori;
  const HasilKuis({super.key, required this.score, required this.total, required this.kategori});

  static int bintang(int score) => score >= 9 ? 3 : score >= 6 ? 2 : 1;

  @override
  State<HasilKuis> createState() => _HasilKuisState();
}

class _HasilKuisState extends State<HasilKuis> {
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AudioProvider>().play('assets/audio/sfx/yay.mp3');
      context.read<ProgressProvider>().tambahBintang(widget.score);
      context.read<ProgressProvider>().simpanSkor(widget.kategori, widget.score);
      if (HasilKuis.bintang(widget.score) >= 2) _confetti.play();
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = HasilKuis.bintang(widget.score);
    return Stack(children: [
      Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confetti,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          numberOfParticles: 40,
          maxBlastForce: 25,
          minBlastForce: 5,
          gravity: 0.25,
          colors: const [AppColors.secondary, AppColors.success, Colors.white, AppColors.pink],
        ),
      ),
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Maskot(emoji: '🎉', size: 88),
            const SizedBox(height: 8),
            Text('Selesai!',
                style: GoogleFonts.nunito(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final aktif = i < b;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('⭐', style: TextStyle(fontSize: 64, color: aktif ? null : Colors.white24)),
                )
                    .animate(delay: (500 + i * 400).ms)
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.4, duration: 300.ms, curve: Curves.easeOutBack);
              }),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(24)),
              child: Text('Skor: ${widget.score}/${widget.total}',
                  style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textMain)),
            ),
            const SizedBox(height: 28),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _tombol('🔄 Main Lagi', AppColors.secondary, () => context.read<KuisProvider>().mulai(widget.kategori)),
              const SizedBox(width: 14),
              _tombol('🏠 Home', AppColors.success, () {
                context.read<KuisProvider>().reset();
                context.go('/');
              }),
            ]),
          ]),
        ),
      ),
    ]);
  }

  Widget _tombol(String teks, Color warna, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: warna,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      child: Text(teks),
    );
  }
}
