import 'dart:ui';

class KuisSoal {
  final String pertanyaan;
  final String kategori;
  final List<String> opsi;
  final int jawabanIndex;
  final String? displayText;
  final int? displayColorHex;

  const KuisSoal({
    required this.pertanyaan,
    required this.kategori,
    required this.opsi,
    required this.jawabanIndex,
    this.displayText,
    this.displayColorHex,
  });
}

// ── Warna publik (dipakai oleh kuis_screen & kuis_data) ──
const warnaMerah = 0xFFEF4444;
const warnaBiru = 0xFF3B82F6;
const warnaKuning = 0xFFEAB308;
const warnaHijau = 0xFF22C55E;
const warnaOranye = 0xFFF97316;
const warnaUngu = 0xFF7C3AED;
const warnaPink = 0xFFEC4899;
const warnaCoklat = 0xFF92400E;

// ── Soal Huruf ──
final List<KuisSoal> hurufSoal = [
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['A', 'B', 'C', 'D'], jawabanIndex: 0, displayText: 'A'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['E', 'F', 'G', 'H'], jawabanIndex: 0, displayText: 'E'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['G', 'I', 'K', 'M'], jawabanIndex: 1, displayText: 'I'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['L', 'N', 'M', 'O'], jawabanIndex: 2, displayText: 'M'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['P', 'O', 'Q', 'R'], jawabanIndex: 1, displayText: 'O'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['R', 'S', 'T', 'U'], jawabanIndex: 1, displayText: 'S'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['U', 'V', 'W', 'X'], jawabanIndex: 0, displayText: 'U'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['D', 'B', 'P', 'R'], jawabanIndex: 1, displayText: 'B'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['H', 'K', 'I', 'J'], jawabanIndex: 1, displayText: 'K'),
  KuisSoal(pertanyaan: 'Huruf apa ini?', kategori: 'huruf', opsi: ['X', 'Y', 'Z', 'W'], jawabanIndex: 2, displayText: 'Z'),
];

// ── Soal Angka ──
final List<KuisSoal> angkaSoal = [
  KuisSoal(pertanyaan: 'Berapa jumlah bintang ini?', kategori: 'angka', opsi: ['1', '2', '3', '4'], jawabanIndex: 0, displayText: '1'),
  KuisSoal(pertanyaan: 'Berapa jumlah ini?', kategori: 'angka', opsi: ['2', '4', '3', '5'], jawabanIndex: 2, displayText: '3'),
  KuisSoal(pertanyaan: 'Berapa jumlah ini?', kategori: 'angka', opsi: ['5', '6', '4', '7'], jawabanIndex: 0, displayText: '5'),
  KuisSoal(pertanyaan: 'Angka berapa ini?', kategori: 'angka', opsi: ['6', '8', '7', '9'], jawabanIndex: 2, displayText: '7'),
  KuisSoal(pertanyaan: 'Angka berapa ini?', kategori: 'angka', opsi: ['1', '3', '2', '4'], jawabanIndex: 2, displayText: '2'),
  KuisSoal(pertanyaan: 'Angka berapa ini?', kategori: 'angka', opsi: ['8', '9', '10', '7'], jawabanIndex: 1, displayText: '9'),
  KuisSoal(pertanyaan: 'Berapa jumlah ini?', kategori: 'angka', opsi: ['3', '5', '4', '6'], jawabanIndex: 2, displayText: '4'),
  KuisSoal(pertanyaan: 'Angka berapa ini?', kategori: 'angka', opsi: ['5', '7', '6', '8'], jawabanIndex: 2, displayText: '6'),
  KuisSoal(pertanyaan: 'Angka berapa ini?', kategori: 'angka', opsi: ['9', '10', '8', '11'], jawabanIndex: 1, displayText: '10'),
  KuisSoal(pertanyaan: 'Angka berapa ini?', kategori: 'angka', opsi: ['7', '9', '8', '6'], jawabanIndex: 2, displayText: '8'),
];

// ── Soal Warna ──
final List<KuisSoal> warnaSoal = [
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Merah', 'Biru', 'Kuning', 'Hijau'], jawabanIndex: 0, displayColorHex: warnaMerah),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Hijau', 'Biru', 'Ungu', 'Pink'], jawabanIndex: 1, displayColorHex: warnaBiru),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Oranye', 'Merah', 'Kuning', 'Hijau'], jawabanIndex: 2, displayColorHex: warnaKuning),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Merah', 'Hijau', 'Biru', 'Kuning'], jawabanIndex: 1, displayColorHex: warnaHijau),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Kuning', 'Merah', 'Oranye', 'Pink'], jawabanIndex: 2, displayColorHex: warnaOranye),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Biru', 'Pink', 'Ungu', 'Merah'], jawabanIndex: 2, displayColorHex: warnaUngu),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Merah', 'Ungu', 'Pink', 'Oranye'], jawabanIndex: 2, displayColorHex: warnaPink),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Hitam', 'Coklat', 'Abu-abu', 'Merah'], jawabanIndex: 1, displayColorHex: warnaCoklat),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Pink', 'Oranye', 'Merah', 'Ungu'], jawabanIndex: 2, displayColorHex: warnaMerah),
  KuisSoal(pertanyaan: 'Warna apa ini?', kategori: 'warna', opsi: ['Ungu', 'Hijau', 'Biru', 'Kuning'], jawabanIndex: 2, displayColorHex: warnaBiru),
];

// ── Soal Hewan ──
final List<KuisSoal> hewanSoal = [
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Kucing', 'Anjing', 'Kelinci', 'Sapi'], jawabanIndex: 0, displayText: '🐱'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Kucing', 'Sapi', 'Anjing', 'Ayam'], jawabanIndex: 2, displayText: '🐶'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Kambing', 'Sapi', 'Kuda', 'Ayam'], jawabanIndex: 1, displayText: '🐮'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Bebek', 'Ayam', 'Burung', 'Kucing'], jawabanIndex: 1, displayText: '🐔'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Katak', 'Ikan', 'Kura-kura', 'Kepiting'], jawabanIndex: 0, displayText: '🐸'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Gajah', 'Harimau', 'Monyet', 'Kuda'], jawabanIndex: 0, displayText: '🐘'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Kambing', 'Harimau', 'Monyet', 'Gajah'], jawabanIndex: 1, displayText: '🐅'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Katak', 'Kura-kura', 'Ikan', 'Kepiting'], jawabanIndex: 2, displayText: '🐟'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Lebah', 'Kupu-kupu', 'Semut', 'Burung'], jawabanIndex: 1, displayText: '🦋'),
  KuisSoal(pertanyaan: 'Hewan apa ini?', kategori: 'hewan', opsi: ['Katak', 'Kepiting', 'Ikan', 'Kura-kura'], jawabanIndex: 3, displayText: '🐢'),
];

// ── Getter per kategori ──
List<KuisSoal> getKuisByKategori(String kategori) {
  switch (kategori) {
    case 'huruf': return hurufSoal;
    case 'angka': return angkaSoal;
    case 'warna': return warnaSoal;
    case 'hewan': return hewanSoal;
    default: return [];
  }
}

/// Dipakai oleh KuisProvider di providers.dart.
/// Ambil [jumlah] soal acak dari [kategori].
List<KuisSoal> buatSoal(String kategori, int jumlah) {
  final all = getKuisByKategori(kategori);
  if (all.isEmpty) return [];
  final shuffled = List<KuisSoal>.from(all)..shuffle();
  return shuffled.take(jumlah.clamp(0, all.length)).toList();
}

/// Map nama warna → hex color. Dipakai oleh kuis_screen.
Color getWarnaDariNama(String name) {
  final map = <String, int>{
    'Merah': warnaMerah,
    'Biru': warnaBiru,
    'Kuning': warnaKuning,
    'Hijau': warnaHijau,
    'Oranye': warnaOranye,
    'Ungu': warnaUngu,
    'Pink': warnaPink,
    'Coklat': warnaCoklat,
    'Hitam': 0xFF000000,
    'Putih': 0xFFFFFFFF,
    'Abu-abu': 0xFF9CA3AF,
  };
  return Color(map[name] ?? 0xFFCCCCCC);
}
