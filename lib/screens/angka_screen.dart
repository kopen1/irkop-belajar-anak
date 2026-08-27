import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/angka_data.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

/// Belajar Angka 1-10 + mini game hitung benda (PRD B.2.2)
class AngkaScreen extends StatefulWidget {
  const AngkaScreen({super.key});

  @override
  State<AngkaScreen> createState() => _AngkaScreenState();
}

class _AngkaScreenState extends State<AngkaScreen> {
  final PageController _controller = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _aktifkan(0));
  }

  void _aktifkan(int i) {
    final a = daftarAngka[i];
    context.read<ProgressProvider>().pelajariAngka('${a.nilai}');
    context.read<AudioProvider>().play(a.audioPath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.blue, Color(0xFF0EA5E9)],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
              child: Column(children: [
                Row(children: [
                  IconButton(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  ),
                  Expanded(
                    child: Text('Belajar Angka',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  Text('${progress.angkaDipelajari.length}/10',
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: progress.angkaDipelajari.length / 10,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                    backgroundColor: Colors.white24,
                    color: AppColors.secondary,
                  ),
                ),
              ]),
            ),
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _controller,
                itemCount: daftarAngka.length,
                onPageChanged: _aktifkan,
                itemBuilder: (context, i) => _KartuAngka(item: daftarAngka[i]),
              ),
            ),
            const Expanded(flex: 2, child: _MiniGameAngka()),
          ]),
        ),
      ),
    );
  }
}

class _KartuAngka extends StatefulWidget {
  final AngkaItem item;
  const _KartuAngka({required this.item});

  @override
  State<_KartuAngka> createState() => _KartuAngkaState();
}

class _KartuAngkaState extends State<_KartuAngka> {
  bool _bump = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.item;
    return GestureDetector(
      onTap: () {
        setState(() => _bump = true);
        context.read<AudioProvider>().play(a.audioPath);
        Future.delayed(const Duration(milliseconds: 250), () {
          if (mounted) setState(() => _bump = false);
        });
      },
      child: AnimatedScale(
        scale: _bump ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: a.warna.withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('${a.nilai}',
                style: GoogleFonts.nunito(fontSize: 96, fontWeight: FontWeight.w800, color: a.warna)),
            Text(a.kata,
                style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textMain)),
            const SizedBox(height: 12),
            // Visual jumlah objek — muncul satu-satu (count-up)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(
                a.nilai,
                (i) => Text(a.emoji, style: const TextStyle(fontSize: 30))
                    .animate(delay: (i * 90).ms)
                    .fadeIn(duration: 200.ms)
                    .slideY(begin: 0.3, duration: 200.ms),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Mini-game: hitung benda yang muncul, tap jawaban benar (PRD B.2.2)
class _MiniGameAngka extends StatefulWidget {
  const _MiniGameAngka();

  @override
  State<_MiniGameAngka> createState() => _MiniGameAngkaState();
}

class _MiniGameAngkaState extends State<_MiniGameAngka> {
  final Random _rng = Random();
  late int _target;
  late String _emoji;
  late List<String> _opsi;
  int _salah = 0;
  bool _locked = false;

  static const _emojiPool = ['⭐', '🍎', '🎈', '🐟', '🌸', '🍌', '🐝', '🚗'];

  @override
  void initState() {
    super.initState();
    _soalBaru();
  }

  void _soalBaru() {
    _target = 1 + _rng.nextInt(10);
    _emoji = _emojiPool[_rng.nextInt(_emojiPool.length)];
    final benar = daftarAngka[_target - 1].kata;
    final distraktor = (daftarAngka.map((e) => e.kata).toList()..shuffle(_rng))
        .where((e) => e != benar)
        .take(2)
        .toList();
    _opsi = [...distraktor, benar]..shuffle(_rng);
    _locked = false;
  }

  void _jawab(String kata) {
    if (_locked) return;
    final audio = context.read<AudioProvider>();
    if (kata == daftarAngka[_target - 1].kata) {
      _locked = true;
      audio.play('assets/audio/sfx/benar.mp3');
      setState(() {});
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(_soalBaru);
      });
    } else {
      audio.play('assets/audio/sfx/salah.mp3');
      setState(() => _salah++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(children: [
        Text('🎮 Mini Game: Ada berapa benda?',
            style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textMain)),
        const SizedBox(height: 8),
        Expanded(
          child: Center(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: List.generate(_target, (_) => Text(_emoji, style: const TextStyle(fontSize: 28))),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final o in _opsi)
              ElevatedButton(
                onPressed: _locked ? null : () => _jawab(o),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  textStyle: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                child: Text(o),
              ),
          ],
        ).animate(target: _salah.toDouble()).shakeX(duration: 400.ms),
      ]),
    );
  }
}
