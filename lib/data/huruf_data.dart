import 'package:flutter/material.dart';

/// Model Huruf — PRD D.2
class HurufItem {
  final String hurufBesar;   // "A"
  final String hurufKecil;   // "a"
  final String contoh;       // "Apel"
  final String emoji;        // Ilustrasi placeholder (gambar real menyusul)
  final String audioPath;    // "assets/audio/huruf/a.mp3"
  final Color warna;         // Warna latar kartu
  final String imagePath;    // opsional — dipakai jika aset real sudah ada
  const HurufItem({
    required this.hurufBesar,
    required this.hurufKecil,
    required this.contoh,
    required this.emoji,
    required this.audioPath,
    required this.warna,
    this.imagePath = '',
  });
}

const List<String> _contoh = [
  'Apel', 'Bola', 'Cicak', 'Domba', 'Es', 'Foto', 'Gajah', 'Harimau', 'Ikan', 'Jeruk',
  'Kucing', 'Lampu', 'Matahari', 'Nanas', 'Ombak', 'Pisang', 'Quran', 'Rumah', 'Sepatu', 'Topi',
  'Ular', 'Vas', 'Wortel', 'Xilofon', 'Yoyo', 'Zebra',
];

const List<String> _emoji = [
  '🍎', '⚽', '🦎', '🐑', '🍧', '📷', '🐘', '🐅', '🐟', '🍊',
  '🐱', '💡', '☀️', '🍍', '🌊', '🍌', '📖', '🏠', '👟', '🎩',
  '🐍', '🏺', '🥕', '🎹', '🪀', '🦓',
];

const List<Color> _palet = [
  Color(0xFF7C3AED), Color(0xFF3B82F6), Color(0xFFEC4899), Color(0xFF22C55E),
  Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF0EA5E9), Color(0xFF8B5CF6),
  Color(0xFF14B8A6), Color(0xFFF97316),
];

final List<HurufItem> daftarHuruf = List.generate(26, (i) {
  final besar = String.fromCharCode(65 + i);
  final kecil = String.fromCharCode(97 + i);
  return HurufItem(
    hurufBesar: besar,
    hurufKecil: kecil,
    contoh: _contoh[i],
    emoji: _emoji[i],
    audioPath: 'assets/audio/huruf/$kecil.mp3',
    warna: _palet[i % _palet.length],
  );
});
