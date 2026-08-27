import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/hasil_kuis.dart';
import '../widgets/kuis_card.dart';
import '../widgets/materi_card.dart';

/// Kuis Interaktif — pilih kategori -> 10 soal -> hasil bintang (PRD B.2.5)
class KuisScreen extends StatelessWidget {
  const KuisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kuis = context.watch<KuisProvider>();
    if (kuis.soalList.isEmpty) return const _PilihKategori();
    if (kuis.isFinished) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, Color(0xFFEC4899)],
            ),
          ),
          child: SafeArea(
            child: HasilKuis(score: kuis.score, total: kuis.soalList.length, kategori: kuis.kategori),
          ),
        ),
      );
    }
    return const _SoalView();
  }
}

class _PilihKategori extends StatelessWidget {
  const _PilihKategori();

  static const _kategori = [
    ('huruf', 'Kuis Huruf', '🔤', AppColors.primary),
    ('angka', 'Kuis Angka', '🔢', AppColors.blue),
    ('warna', 'Kuis Warna', '🎨', AppColors.pink),
    ('hewan', 'Kuis Hewan', '🦁', AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.secondary, AppColors.primary],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () {
                    context.read<KuisProvider>().reset();
                    context.go('/');
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                ),
                Expanded(
                  child: Text('Kuis 🧠',
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
                  Text('Mau kuis apa hari ini?',
                      style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 16),
                  ...List.generate(_kategori.length, (i) {
                    final (kat, judul, emoji, warna) = _kategori[i];
                    final best = progress.skorTertinggi[kat] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: MateriCard(
                        onTap: () {
                          context.read<AudioProvider>().play('assets/audio/sfx/klik.mp3');
                          context.read<KuisProvider>().mulai(kat);
                        },
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(children: [
                              Text(emoji, style: const TextStyle(fontSize: 44)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(judul,
                                    style: GoogleFonts.nunito(
                                        fontSize: 24, fontWeight: FontWeight.w800, color: warna)),
                              ),
                              Text('🏆 $best',
                                  style: GoogleFonts.nunito(
                                      fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.secondary)),
                            ]),
                          ),
                        ),
                      ),
                    )
                        .animate(delay: (80 * i).ms)
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.15, duration: 300.ms);
                  }),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SoalView extends StatefulWidget {
  const _SoalView();

  @override
  State<_SoalView> createState() => _SoalViewState();
}

class _SoalViewState extends State<_SoalView> {
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(milliseconds: 900));

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _pilih(int index) {
    final kuis = context.read<KuisProvider>();
    if (kuis.answered) return;
    final audio = context.read<AudioProvider>();
    final benar = kuis.jawab(index);
    if (benar) {
      // Benar -> konfeti + suara tepuk tangan (PRD B.2.5)
      _confetti.play();
      audio.play('assets/audio/sfx/benar.mp3');
    } else {
      // Salah -> suara lembut "Coba lagi!" — tidak menakuti (PRD B.2.5)
      audio.play('assets/audio/sfx/salah.mp3');
    }
    Future.delayed(Duration(milliseconds: benar ? 1200 : 1700), () {
      if (mounted) context.read<KuisProvider>().lanjut();
    });
  }

  @override
  Widget build(BuildContext context) {
    final kuis = context.watch<KuisProvider>();
    final soal = kuis.soalSekarang!;
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6D28D9), Color(0xFF3B82F6)],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 25,
            maxBlastForce: 22,
            minBlastForce: 6,
            gravity: 0.3,
            colors: const [
              AppColors.success, AppColors.secondary, AppColors.pink, AppColors.blue, AppColors.primary,
            ],
          ),
        ),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () {
                    context.read<KuisProvider>().reset();
                    context.go('/');
                  },
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
                Expanded(
                  child: Text('Soal ${kuis.currentIndex + 1}/${kuis.soalList.length}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                Text('⭐ ${kuis.score}',
                    style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.secondary)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: LinearProgressIndicator(
                value: (kuis.currentIndex + 1) / kuis.soalList.length,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
                backgroundColor: Colors.white24,
                color: AppColors.secondary,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    KuisCard(soal: soal),
                    const SizedBox(height: 16),
                    for (int i = 0; i < soal.opsi.length; i++) ...[
                      OpsiButton(
                        teks: soal.opsi[i],
                        index: i,
                        dipilih: kuis.dipilih,
                        jawabanIndex: soal.jawabanIndex,
                        answered: kuis.answered,
                        onTap: () => _pilih(i),
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (kuis.answered)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: kuis.dipilih == soal.jawabanIndex ? AppColors.success : AppColors.danger,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            kuis.dipilih == soal.jawabanIndex ? 'Hebat! 🎉' : 'Coba lagi! 😊',
                            style: GoogleFonts.nunito(
                                fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ).animate().fadeIn(duration: 300.ms),
                      ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
