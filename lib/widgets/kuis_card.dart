import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/kuis_data.dart';
import '../theme/app_theme.dart';

/// Kartu soal — visual besar + pertanyaan (PRD B.2.5)
class KuisCard extends StatelessWidget {
  final KuisSoal soal;
  const KuisCard({super.key, required this.soal});

  @override
  Widget build(BuildContext context) {
    final Widget visual;
    if (soal.warnaVisual != null) {
      visual = Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: soal.warnaVisual,
          shape: BoxShape.circle,
          border: Border.all(width: 4, color: AppColors.textMain.withOpacity(0.1)),
        ),
        child: Center(child: Text('?', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white.withOpacity(0.85)))),
      );
    } else if (soal.jumlahVisual != null) {
      visual = Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: List.generate(
          soal.jumlahVisual!,
          (_) => Text(soal.emojiVisual, style: const TextStyle(fontSize: 34)),
        ),
      );
    } else if (soal.kategori == 'huruf') {
      visual = Text(soal.emojiVisual,
          style: GoogleFonts.nunito(fontSize: 110, fontWeight: FontWeight.w800, color: AppColors.primary));
    } else {
      visual = Text(soal.emojiVisual, style: const TextStyle(fontSize: 96));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8))],
      ),
      child: Column(children: [
        visual,
        const SizedBox(height: 14),
        Text(soal.pertanyaan,
            style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textMain)),
      ]),
    );
  }
}

/// Tombol opsi jawaban — benar hijau / salah merah lembut (PRD C.2, C.4)
class OpsiButton extends StatelessWidget {
  final String teks;
  final int index;
  final int? dipilih;
  final int jawabanIndex;
  final bool answered;
  final VoidCallback onTap;

  const OpsiButton({
    super.key,
    required this.teks,
    required this.index,
    required this.dipilih,
    required this.jawabanIndex,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final benar = answered && index == jawabanIndex;
    final salah = answered && index == dipilih && index != jawabanIndex;
    final bg = benar
        ? AppColors.success
        : salah
            ? AppColors.danger
            : AppColors.primary.withOpacity(0.08);
    final fg = (benar || salah) ? Colors.white : AppColors.textMain;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: answered ? null : onTap,
          child: Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(teks,
                  style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: fg)),
              if (benar)
                const Padding(padding: EdgeInsets.only(left: 8), child: Text('✅', style: TextStyle(fontSize: 20))),
              if (salah)
                const Padding(padding: EdgeInsets.only(left: 8), child: Text('😅', style: TextStyle(fontSize: 20))),
            ]),
          ),
        ),
      ),
    );
  }
}
