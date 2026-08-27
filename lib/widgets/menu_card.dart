import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Menu card besar + progress ring (PRD B.2.7, C.1)
class MenuCard extends StatelessWidget {
  final String emoji;
  final String label;
  final Color warna;
  final double progress; // 0.0 - 1.0
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.warna,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final persen = (progress * 100).round();
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      shadowColor: warna.withOpacity(0.4),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  color: warna,
                  backgroundColor: warna.withOpacity(0.12),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(emoji, style: const TextStyle(fontSize: 34)),
            ]),
            const SizedBox(height: 10),
            Text(label,
                style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textMain)),
            Text('$persen% dipelajari',
                style: GoogleFonts.nunito(
                    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMain.withOpacity(0.6))),
          ]),
        ),
      ),
    );
  }
}
