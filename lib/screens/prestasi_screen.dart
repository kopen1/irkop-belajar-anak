import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/maskot.dart';

/// Layar Prestasi — bintang, badge per kategori, skor all-time (PRD B.2.8)
class PrestasiScreen extends StatelessWidget {
  const PrestasiScreen({super.key});

  static const _badge = [
    ('huruf', 'Juara Huruf', '🔤'),
    ('angka', 'Juara Angka', '🔢'),
    ('warna', 'Juara Warna', '🎨'),
    ('hewan', 'Juara Hewan', '🦁'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD4AF37), AppColors.primary],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                ),
                Expanded(
                  child: Text('Prestasi 🏆',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                const SizedBox(width: 48),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
                    child: Column(children: [
                      const Maskot(emoji: '⭐', size: 72),
                      const SizedBox(height: 8),
                      Text('${p.totalBintang}',
                          style: GoogleFonts.nunito(
                              fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.secondary)),
                      Text('bintang terkumpul',
                          style: GoogleFonts.nunito(
                              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textMain)),
                    ]),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, duration: 300.ms),
                  const SizedBox(height: 18),
                  Text('Koleksi Badge',
                      style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: List.generate(_badge.length, (i) {
                      final (kat, nama, emoji) = _badge[i];
                      final skor = p.skorTertinggi[kat] ?? 0;
                      final juara = skor >= 8;
                      return Container(
                        decoration: BoxDecoration(
                          color: juara ? Colors.white : Colors.white24,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(juara ? emoji : '🔒', style: const TextStyle(fontSize: 36)),
                          const SizedBox(height: 4),
                          Text(nama,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: juara ? AppColors.textMain : Colors.white)),
                          Text('Skor terbaik: $skor',
                              style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: juara ? AppColors.textMain : Colors.white70)),
                        ]),
                      )
                          .animate(delay: (120 * i).ms)
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.15, duration: 300.ms);
                    }),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(24)),
                    child: Text('Terus bermain kuis untuk membuka semua badge! 💪',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
