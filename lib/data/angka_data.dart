import 'package:flutter/material.dart';

/// Model Angka — PRD D.2
class AngkaItem {
  final int nilai;
  final String kata;      // "satu"
  final String emoji;     // visual jumlah objek
  final Color warna;
  final String audioPath; // "assets/audio/angka/1.mp3"
  const AngkaItem(this.nilai, this.kata, this.emoji, this.warna, this.audioPath);
}

const List<String> _kata = [
  'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan', 'sepuluh',
];

const List<String> _emoji = ['🍎', '⭐', '🎈', '🐟', '🌸', '🍌', '🐝', '🚗', '🍇', '🎉'];

const List<Color> _warna = [
  Color(0xFFEF4444), Color(0xFF3B82F6), Color(0xFF22C55E), Color(0xFFF59E0B),
  Color(0xFFEC4899), Color(0xFF8B5CF6), Color(0xFF14B8A6), Color(0xFFF97316),
  Color(0xFF0EA5E9), Color(0xFF7C3AED),
];

final List<AngkaItem> daftarAngka = List.generate(
  10,
  (i) => AngkaItem(i + 1, _kata[i], _emoji[i], _warna[i], 'assets/audio/angka/${i + 1}.mp3'),
);
