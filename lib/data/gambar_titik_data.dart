import 'dart:ui';

class TitikPuzzle {
  final String nama;
  final String kategori;
  final List<Offset> points;
  final Color color;
  final int difficulty;
  final String completedText;

  const TitikPuzzle({
    required this.nama,
    required this.kategori,
    required this.points,
    required this.color,
    required this.difficulty,
    required this.completedText,
  });

  List<String> get labels {
    if (kategori == 'angka') return List.generate(points.length, (i) => '${i + 1}');
    return List.generate(points.length, (i) => String.fromCharCode(65 + i));
  }
}

final puzzles = [
  // ── Angka ──
  TitikPuzzle(nama: 'Garis', kategori: 'angka', difficulty: 1, color: const Color(0xFF3B82F6),
    completedText: 'Garis! Garis lurus.',
    points: [const Offset(0.2, 0.5), const Offset(0.8, 0.5)]),
  TitikPuzzle(nama: 'Segitiga', kategori: 'angka', difficulty: 1, color: const Color(0xFF22C55E),
    completedText: 'Segitiga! Tiga sisi sama.',
    points: [const Offset(0.15,0.85), const Offset(0.5,0.15), const Offset(0.85,0.85)]),
  TitikPuzzle(nama: 'Kotak', kategori: 'angka', difficulty: 1, color: const Color(0xFFF59E0B),
    completedText: 'Kotak! Empat sisi sama panjang.',
    points: [const Offset(0.2,0.2), const Offset(0.8,0.2), const Offset(0.8,0.8), const Offset(0.2,0.8)]),
  TitikPuzzle(nama: 'Berlian', kategori: 'angka', difficulty: 1, color: const Color(0xFFEC4899),
    completedText: 'Berlian! Wujud berlian.',
    points: [const Offset(0.5,0.1), const Offset(0.85,0.5), const Offset(0.5,0.9), const Offset(0.15,0.5)]),
  TitikPuzzle(nama: 'Bintang', kategori: 'angka', difficulty: 2, color: const Color(0xFF7C3AED),
    completedText: 'Bintang! Bintang bercahaya.',
    points: [const Offset(0.5,0.05), const Offset(0.9,0.35), const Offset(0.65,0.9), const Offset(0.35,0.9), const Offset(0.1,0.35)]),
  TitikPuzzle(nama: 'Panah', kategori: 'angka', difficulty: 2, color: const Color(0xFF06B6D4),
    completedText: 'Panah! Menunjuk ke kanan.',
    points: [const Offset(0.1,0.3), const Offset(0.6,0.3), const Offset(0.95,0.5), const Offset(0.6,0.7), const Offset(0.1,0.7)]),
  TitikPuzzle(nama: 'Rumah', kategori: 'angka', difficulty: 3, color: const Color(0xFFF97316),
    completedText: 'Rumah! Rumah yang cantik.',
    points: [const Offset(0.15,0.45), const Offset(0.5,0.1), const Offset(0.85,0.45), const Offset(0.85,0.9), const Offset(0.55,0.9), const Offset(0.55,0.6), const Offset(0.15,0.6)]),
  TitikPuzzle(nama: 'Hati', kategori: 'angka', difficulty: 3, color: const Color(0xFFEF4444),
    completedText: 'Hati! Simbol cinta.',
    points: [const Offset(0.5,0.2), const Offset(0.8,0.3), const Offset(0.9,0.55), const Offset(0.7,0.75), const Offset(0.5,0.95), const Offset(0.3,0.75), const Offset(0.1,0.55), const Offset(0.2,0.3)]),
  // ── Huruf ──
  TitikPuzzle(nama: 'Garis', kategori: 'huruf', difficulty: 1, color: const Color(0xFF8B5CF6),
    completedText: 'Garis!',
    points: [const Offset(0.2, 0.5), const Offset(0.8, 0.5)]),
  TitikPuzzle(nama: 'Segitiga', kategori: 'huruf', difficulty: 1, color: const Color(0xFF4ADE80),
    completedText: 'Segitiga!',
    points: [const Offset(0.15,0.85), const Offset(0.5,0.15), const Offset(0.85,0.85)]),
  TitikPuzzle(nama: 'Kotak', kategori: 'huruf', difficulty: 1, color: const Color(0xFFFBBF24),
    completedText: 'Kotak!',
    points: [const Offset(0.2,0.2), const Offset(0.8,0.2), const Offset(0.8,0.8), const Offset(0.2,0.8)]),
  TitikPuzzle(nama: 'Berlian', kategori: 'huruf', difficulty: 1, color: const Color(0xFFF472B6),
    completedText: 'Berlian!',
    points: [const Offset(0.5,0.1), const Offset(0.85,0.5), const Offset(0.5,0.9), const Offset(0.15,0.5)]),
  TitikPuzzle(nama: 'Bintang', kategori: 'huruf', difficulty: 2, color: const Color(0xFFA78BFA),
    completedText: 'Bintang!',
    points: [const Offset(0.5,0.05), const Offset(0.9,0.35), const Offset(0.65,0.9), const Offset(0.35,0.9), const Offset(0.1,0.35)]),
  TitikPuzzle(nama: 'Panah', kategori: 'huruf', difficulty: 2, color: const Color(0xFF22D3EE),
    completedText: 'Panah!',
    points: [const Offset(0.1,0.3), const Offset(0.6,0.3), const Offset(0.95,0.5), const Offset(0.6,0.7), const Offset(0.1,0.7)]),
  TitikPuzzle(nama: 'Rumah', kategori: 'huruf', difficulty: 3, color: const Color(0xFFFB923C),
    completedText: 'Rumah!',
    points: [const Offset(0.15,0.45), const Offset(0.5,0.1), const Offset(0.85,0.45), const Offset(0.85,0.9), const Offset(0.55,0.9), const Offset(0.55,0.6), const Offset(0.15,0.6)]),
  TitikPuzzle(nama: 'Hati', kategori: 'huruf', difficulty: 3, color: const Color(0xFFF87171),
    completedText: 'Hati!',
    points: [const Offset(0.5,0.2), const Offset(0.8,0.3), const Offset(0.9,0.55), const Offset(0.7,0.75), const Offset(0.5,0.95), const Offset(0.3,0.75), const Offset(0.1,0.55), const Offset(0.2,0.3)]),
];

List<TitikPuzzle> getPuzzles(String kategori) =>
    puzzles.where((p) => p.kategori == kategori).toList();
