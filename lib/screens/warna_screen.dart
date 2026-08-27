import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/warna_data.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

/// Belajar Warna — 12 warna, latar berubah immersive + mini game (PRD B.2.3)
class WarnaScreen extends StatefulWidget {
  const WarnaScreen({super.key});

  @override
  State<WarnaScreen> createState() => _WarnaScreenState();
}

class _WarnaScreenState extends State<WarnaScreen> {
  WarnaItem? _dipilih;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    final dipilih = _dipilih;
    final bg = dipilih?.warna ?? AppColors.background;
    final onColor = (dipilih == null || dipilih.teksGelap) ? AppColors.textMain : Colors.white;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(color: bg),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () => context.go('/'),
                  icon: Icon(Icons.arrow_back, color: onColor, size: 30),
                ),
                Expanded(
                  child: Text('Belajar Warna',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(fontSize: 30, fontWeight: FontWeight.w800, color: onColor)),
                ),
                Text('${p.warnaDipelajari.length}/12',
                    style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: onColor)),
              ]),
            ),
            // Area warna terpilih — immersive (PRD B.2.3)
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: dipilih == null ? 0 : 190,
              child: dipilih == null
                  ? const SizedBox.shrink()
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: dipilih.warna,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 6),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16)],
                        ),
                        child: Center(child: Text(dipilih.emoji, style: const TextStyle(fontSize: 52))),
                      ),
                      const SizedBox(height: 8),
                      Text('Ini warna ${dipilih.nama}',
                          style: GoogleFonts.nunito(fontSize: 30, fontWeight: FontWeight.w800, color: onColor)),
                      Text('${dipilih.emoji} ${dipilih.contoh}',
                          style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: onColor)),
                    ]),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                children: List.generate(daftarWarna.length, (i) {
                  final w = daftarWarna[i];
                  return _UbinWarna(item: w, onTap: () {
                    setState(() => _dipilih = w);
                    context.read<ProgressProvider>().pelajariWarna(w.nama);
                    context.read<AudioProvider>().play(w.audioPath);
                  });
                }),
              ),
            ),
            const _MiniGameWarna(),
          ]),
        ),
      ),
    );
  }
}

class _UbinWarna extends StatefulWidget {
  final WarnaItem item;
  final VoidCallback onTap;
  const _UbinWarna({required this.item, required this.onTap});

  @override
  State<_UbinWarna> createState() => _UbinWarnaState();
}

class _UbinWarnaState extends State<_UbinWarna> {
  bool _bump = false;

  @override
  Widget build(BuildContext context) {
    final w = widget.item;
    final labelColor = w.teksGelap ? AppColors.textMain : w.warna;
    return GestureDetector(
      onTap: () {
        setState(() => _bump = true);
        widget.onTap();
        Future.delayed(const Duration(milliseconds: 250), () {
          if (mounted) setState(() => _bump = false);
        });
      },
      child: AnimatedScale(
        scale: _bump ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: w.warna,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [BoxShadow(color: w.warna.withOpacity(0.5), blurRadius: 12)],
            ),
          ),
          const SizedBox(height: 6),
          Text(w.nama,
              style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: labelColor)),
        ]),
      ),
    );
  }
}

class _Benda {
  final String emoji;
  final WarnaItem warna;
  const _Benda(this.emoji, this.warna);
}

/// Mini-game: "Tap semua benda yang berwarna X!" (PRD B.2.3)
class _MiniGameWarna extends StatefulWidget {
  const _MiniGameWarna();

  @override
  State<_MiniGameWarna> createState() => _MiniGameWarnaState();
}

class _MiniGameWarnaState extends State<_MiniGameWarna> {
  final Random _rng = Random();
  late WarnaItem _target;
  late List<_Benda> _benda;
  final Set<int> _ketemu = {};
  int _salah = 0;
  bool _selesai = false;

  @override
  void initState() {
    super.initState();
    _rondeBaru();
  }

  void _rondeBaru() {
    _target = daftarWarna[_rng.nextInt(daftarWarna.length)];
    const emojiPool = ['🍎', '🌸', '🚗', '🎈', '🐟', '🦋', '⚽', '🍀'];
    _benda = [];
    final jumlahTarget = 2 + _rng.nextInt(2); // 2-3 benda target
    for (int i = 0; i < jumlahTarget; i++) {
      _benda.add(_Benda(emojiPool[_rng.nextInt(emojiPool.length)], _target));
    }
    for (int i = 0; i < 6 - jumlahTarget; i++) {
      WarnaItem w;
      do {
        w = daftarWarna[_rng.nextInt(daftarWarna.length)];
      } while (w.nama == _target.nama);
      _benda.add(_Benda(emojiPool[_rng.nextInt(emojiPool.length)], w));
    }
    _benda.shuffle(_rng);
    _ketemu.clear();
    _selesai = false;
  }

  void _tapBenda(int i) {
    if (_selesai) return;
    final audio = context.read<AudioProvider>();
    if (_benda[i].warna.nama == _target.nama) {
      if (_ketemu.add(i)) {
        audio.play('assets/audio/sfx/benar.mp3');
        final totalTarget = _benda.where((e) => e.warna.nama == _target.nama).length;
        if (_ketemu.length == totalTarget) {
          _selesai = true;
          audio.play('assets/audio/sfx/yay.mp3');
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (mounted) setState(_rondeBaru);
          });
        }
        setState(() {});
      }
    } else {
      audio.play('assets/audio/sfx/salah.mp3');
      setState(() => _salah++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(children: [
        Text('🎮 Tap semua benda yang berwarna ${_target.nama.toUpperCase()}!',
            style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textMain)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(_benda.length, (i) {
            final b = _benda[i];
            final ketemu = _ketemu.contains(i);
            return GestureDetector(
              onTap: () => _tapBenda(i),
              child: Opacity(
                opacity: ketemu ? 0.3 : 1,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: b.warna.warna,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.textMain.withOpacity(0.1), width: 2),
                  ),
                  child: Center(child: Text(b.emoji, style: const TextStyle(fontSize: 26))),
                ),
              ),
            );
          }),
        ).animate(target: _salah.toDouble()).shakeX(duration: 400.ms),
      ]),
    );
  }
}
