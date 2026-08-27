import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/hewan_data.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

/// Belajar Hewan — 20 hewan + filter kategori + fakta (PRD B.2.4)
class HewanScreen extends StatefulWidget {
  const HewanScreen({super.key});

  @override
  State<HewanScreen> createState() => _HewanScreenState();
}

class _HewanScreenState extends State<HewanScreen> {
  String _filter = 'semua';
  HewanItem? _detail;

  static const _filterLabel = {
    'semua': '🐾 Semua',
    'darat': '🏞️ Darat',
    'air': '💧 Air',
    'terbang': '☁️ Terbang',
  };

  List<HewanItem> get _daftar =>
      _filter == 'semua' ? daftarHewan : daftarHewan.where((e) => e.kategori == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    final daftar = _daftar;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.success, Color(0xFF14B8A6)],
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
                    child: Text('Belajar Hewan',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  Text('${p.hewanDipelajari.length}/20',
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      for (final e in _filterLabel.entries)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(e.value),
                            selected: _filter == e.key,
                            onSelected: (_) => setState(() => _filter = e.key),
                            labelStyle: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _filter == e.key ? Colors.white : AppColors.textMain),
                            selectedColor: AppColors.primary,
                            backgroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ]),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14),
                itemCount: daftar.length,
                itemBuilder: (context, i) => _KartuHewan(
                  item: daftar[i],
                  onTap: () {
                    context.read<ProgressProvider>().pelajariHewan(daftar[i].nama);
                    context.read<AudioProvider>().play(daftar[i].audioPath);
                    setState(() => _detail = daftar[i]);
                  },
                ),
              ),
            ),
            // Info singkat: nama + suara + fakta (PRD B.2.4)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: _detail == null
                  ? Text('👆 Tap hewan untuk dengar suaranya!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textMain))
                  : Row(children: [
                      Text(_detail!.emoji, style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${_detail!.nama} — ${_detail!.suara}',
                              style: GoogleFonts.nunito(
                                  fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textMain)),
                          Text(_detail!.fakta,
                              style: GoogleFonts.nunito(fontSize: 14, color: AppColors.textMain)),
                        ]),
                      ),
                      IconButton(
                        onPressed: () => context.read<AudioProvider>().play(_detail!.audioPath),
                        icon: const Icon(Icons.volume_up, color: AppColors.primary, size: 30),
                      ),
                    ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _KartuHewan extends StatefulWidget {
  final HewanItem item;
  final VoidCallback onTap;
  const _KartuHewan({required this.item, required this.onTap});

  @override
  State<_KartuHewan> createState() => _KartuHewanState();
}

class _KartuHewanState extends State<_KartuHewan> {
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(h.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 6),
            Text(h.nama,
                style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textMain)),
            Text(h.suara,
                style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ]),
        ),
      ),
    );
  }
}
