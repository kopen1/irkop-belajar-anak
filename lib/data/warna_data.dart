import 'package:flutter/material.dart';

/// Model Warna — PRD D.2 (12 warna dasar, PRD B.2.3)
class WarnaItem {
  final String nama;
  final Color warna;
  final bool teksGelap; // untuk warna terang agar label tetap terbaca
  final String contoh;  // contoh benda berwarna itu
  final String emoji;
  final String audioPath;
  const WarnaItem(this.nama, this.warna, this.teksGelap, this.contoh, this.emoji, this.audioPath);
}

const List<WarnaItem> daftarWarna = [
  WarnaItem('Merah', Color(0xFFEF4444), false, 'Apel', '🍎', 'assets/audio/warna/merah.mp3'),
  WarnaItem('Biru', Color(0xFF3B82F6), false, 'Laut', '🌊', 'assets/audio/warna/biru.mp3'),
  WarnaItem('Kuning', Color(0xFFFACC15), false, 'Matahari', '☀️', 'assets/audio/warna/kuning.mp3'),
  WarnaItem('Hijau', Color(0xFF22C55E), false, 'Daun', '🍃', 'assets/audio/warna/hijau.mp3'),
  WarnaItem('Oranye', Color(0xFFF97316), false, 'Jeruk', '🍊', 'assets/audio/warna/oranye.mp3'),
  WarnaItem('Ungu', Color(0xFF8B5CF6), false, 'Anggur', '🍇', 'assets/audio/warna/ungu.mp3'),
  WarnaItem('Pink', Color(0xFFEC4899), false, 'Bunga', '🌸', 'assets/audio/warna/pink.mp3'),
  WarnaItem('Coklat', Color(0xFF92400E), false, 'Cokelat', '🍫', 'assets/audio/warna/coklat.mp3'),
  WarnaItem('Hitam', Color(0xFF1F2937), false, 'Bayangan', '🖤', 'assets/audio/warna/hitam.mp3'),
  WarnaItem('Putih', Color(0xFFF9FAFB), true, 'Awan', '☁️', 'assets/audio/warna/putih.mp3'),
  WarnaItem('Abu-abu', Color(0xFF9CA3AF), false, 'Gajah', '🐘', 'assets/audio/warna/abuabu.mp3'),
  WarnaItem('Emas', Color(0xFFD4AF37), false, 'Medali', '🥇', 'assets/audio/warna/emas.mp3'),
];
