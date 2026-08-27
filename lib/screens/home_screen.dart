import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/maskot.dart';
import '../widgets/menu_card.dart';

/// Home — 6 menu card + gradient + maskot + mute (PRD B.2.7)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final audio = context.watch<AudioProvider>();
    final theme = context.watch<ThemeProvider>();

    final menus = [
      _Menu('Huruf', '🔤', AppColors.primary, '/huruf', progress.persen(progress.hurufDipelajari.length, 26)),
      _Menu('Angka', '🔢', AppColors.blue, '/angka', progress.persen(progress.angkaDipelajari.length, 10)),
      _Menu('Warna', '🎨', AppColors.pink, '/warna', progress.persen(progress.warnaDipelajari.length, 12)),
      _Menu('Hewan', '🦁', AppColors.success, '/hewan', progress.persen(progress.hewanDipelajari.length, 20)),
      _Menu('Kuis', '🧠', AppColors.secondary, '/kuis',
          progress.persen(progress.skorTertinggi.values.fold(0, (m, s) => s > m ? s : m), 10)),
      _Menu('Prestasi', '🏆', const Color(0xFFD4AF37), '/prestasi', progress.persen(progress.totalBintang, 40)),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C3AED), Color(0xFF5B4BEA), Color(0xFF3B82F6)],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(children: [
                const Maskot(emoji: '🤖', size: 42),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Belajar Anak',
                      style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                IconButton(
                  tooltip: 'Mode gelap',
                  onPressed: theme.toggle,
                  icon: Icon(theme.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white70),
                ),
                // Tombol mute di pojok kanan atas (PRD B.2.7)
                IconButton(
                  tooltip: 'Mute',
                  onPressed: audio.toggleMute,
                  icon: Icon(audio.isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white, size: 30),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('⭐ ${progress.totalBintang} bintang terkumpul',
                    style: GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white70)),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.92,
                children: List.generate(menus.length, (i) {
                  final m = menus[i];
                  return MenuCard(
                    emoji: m.emoji,
                    label: m.label,
                    warna: m.warna,
                    progress: m.progress,
                    onTap: () {
                      context.read<AudioProvider>().play('assets/audio/sfx/klik.mp3');
                      context.push(m.route);
                    },
                  )
                      .animate(delay: (80 * i).ms)
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.2, duration: 300.ms);
                }),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Menu {
  final String label;
  final String emoji;
  final Color warna;
  final String route;
  final double progress;
  const _Menu(this.label, this.emoji, this.warna, this.route, this.progress);
}
