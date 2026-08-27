import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/huruf_data.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

/// Belajar Huruf A-Z — 26 kartu carousel horizontal (PRD B.2.1)
class HurufScreen extends StatefulWidget {
  const HurufScreen({super.key});

  @override
  State<HurufScreen> createState() => _HurufScreenState();
}

class _HurufScreenState extends State<HurufScreen> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _aktifkan(0));
  }

  void _aktifkan(int i) {
    final h = daftarHuruf[i];
    context.read<ProgressProvider>().pelajariHuruf(h.hurufBesar);
    context.read<AudioProvider>().play(h.audioPath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final pelajari = progress.hurufDipelajari.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, Color(0xFFA78BFA)],
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
                    child: Text('Belajar Huruf',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  Text('$pelajari/26',
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: pelajari / 26,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                    backgroundColor: Colors.white24,
                    color: AppColors.secondary,
                  ),
                ),
              ]),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: daftarHuruf.length,
                onPageChanged: (i) {
                  setState(() => _index = i);
                  _aktifkan(i);
                },
                itemBuilder: (context, i) => _KartuHuruf(item: daftarHuruf[i], onTap: () => _aktifkan(i)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _tombol('◀ Sebelumnya', _index > 0,
                    () => _controller.previousPage(duration: 300.ms, curve: Curves.easeOut)),
                _tombol('Berikutnya ▶', _index < daftarHuruf.length - 1,
                    () => _controller.nextPage(duration: 300.ms, curve: Curves.easeOut)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _tombol(String teks, bool aktif, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: aktif ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: aktif ? Colors.white : Colors.white24,
        foregroundColor: AppColors.primary,
        disabledForegroundColor: Colors.white38,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: GoogleFonts.nunito(fontSize: 19, fontWeight: FontWeight.w800),
      ),
      child: Text(teks),
    );
  }
}

class _KartuHuruf extends StatefulWidget {
  final HurufItem item;
  final VoidCallback onTap;
  const _KartuHuruf({required this.item, required this.onTap});

  @override
  State<_KartuHuruf> createState() => _KartuHurufState();
}

class _KartuHurufState extends State<_KartuHuruf> {
  bool _bump = false;

  @override
  Widget build(BuildContext context) {
    final h = widget.item;
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: h.warna.withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('${h.hurufBesar}${h.hurufKecil}',
                style: GoogleFonts.nunito(fontSize: 110, fontWeight: FontWeight.w800, color: h.warna)),
            const SizedBox(height: 6),
            Text(h.emoji, style: const TextStyle(fontSize: 76)),
            const SizedBox(height: 6),
            Text(h.contoh,
                style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textMain)),
          ]),
        ),
      ),
    );
  }
}
