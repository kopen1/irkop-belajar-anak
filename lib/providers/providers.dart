import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/kuis_data.dart';
import '../services/audio_service.dart';

/// ===== AudioProvider — PRD D.3 =====
class AudioProvider extends ChangeNotifier {
  String currentAudio = '';
  bool get isMuted => AudioService.isMuted;

  Future<void> play(String assetPath) async {
    currentAudio = assetPath;
    notifyListeners();
    await AudioService.play(assetPath);
  }

  Future<void> stop() async {
    currentAudio = '';
    await AudioService.stop();
    notifyListeners();
  }

  void toggleMute() {
    if (AudioService.isMuted) {
      AudioService.unmute();
    } else {
      AudioService.stop();
      AudioService.mute();
    }
    notifyListeners();
  }
}

/// ===== ProgressProvider — PRD D.3 =====
class ProgressProvider extends ChangeNotifier {
  static const _kHuruf = 'huruf_dipelajari';
  static const _kAngka = 'angka_dipelajari';
  static const _kWarna = 'warna_dipelajari';
  static const _kHewan = 'hewan_dipelajari';
  static const _kBintang = 'total_bintang';
  static const _kSkor = 'skor_';

  final Set<String> hurufDipelajari = {};
  final Set<String> angkaDipelajari = {};
  final Set<String> warnaDipelajari = {};
  final Set<String> hewanDipelajari = {};
  int totalBintang = 0;
  final Map<String, int> skorTertinggi = {};

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    hurufDipelajari.addAll(p.getStringList(_kHuruf) ?? []);
    angkaDipelajari.addAll(p.getStringList(_kAngka) ?? []);
    warnaDipelajari.addAll(p.getStringList(_kWarna) ?? []);
    hewanDipelajari.addAll(p.getStringList(_kHewan) ?? []);
    totalBintang = p.getInt(_kBintang) ?? 0;
    for (final k in ['huruf', 'angka', 'warna', 'hewan']) {
      skorTertinggi[k] = p.getInt('$_kSkor$k') ?? 0;
    }
  }

  Future<void> _simpan(String key, Set<String> nilai) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(key, nilai.toList());
  }

  Future<void> pelajariHuruf(String v) async {
    if (hurufDipelajari.add(v)) {
      await _simpan(_kHuruf, hurufDipelajari);
      notifyListeners();
    }
  }

  Future<void> pelajariAngka(String v) async {
    if (angkaDipelajari.add(v)) {
      await _simpan(_kAngka, angkaDipelajari);
      notifyListeners();
    }
  }

  Future<void> pelajariWarna(String v) async {
    if (warnaDipelajari.add(v)) {
      await _simpan(_kWarna, warnaDipelajari);
      notifyListeners();
    }
  }

  Future<void> pelajariHewan(String v) async {
    if (hewanDipelajari.add(v)) {
      await _simpan(_kHewan, hewanDipelajari);
      notifyListeners();
    }
  }

  double persen(int dipelajari, int total) =>
      total == 0 ? 0.0 : (dipelajari / total).clamp(0.0, 1.0).toDouble();

  Future<void> tambahBintang(int n) async {
    totalBintang += n;
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kBintang, totalBintang);
    notifyListeners();
  }

  Future<void> simpanSkor(String kategori, int skor) async {
    if (skor > (skorTertinggi[kategori] ?? 0)) {
      skorTertinggi[kategori] = skor;
      final p = await SharedPreferences.getInstance();
      await p.setInt('$_kSkor$kategori', skor);
      notifyListeners();
    }
  }
}

/// ===== KuisProvider — PRD D.3 =====
class KuisProvider extends ChangeNotifier {
  final List<KuisSoal> soalList = [];
  int currentIndex = 0;
  int score = 0;
  bool isFinished = false;
  bool answered = false;
  int? dipilih;
  String kategori = 'hewan';

  KuisSoal? get soalSekarang =>
      currentIndex < soalList.length ? soalList[currentIndex] : null;

  void mulai(String kategori, {int jumlah = 10}) {
    this.kategori = kategori;
    soalList
      ..clear()
      ..addAll(buatSoal(kategori, jumlah));
    currentIndex = 0;
    score = 0;
    isFinished = false;
    answered = false;
    dipilih = null;
    notifyListeners();
  }

  bool jawab(int index) {
    if (answered || isFinished || soalSekarang == null) return false;
    answered = true;
    dipilih = index;
    final benar = index == soalSekarang!.jawabanIndex;
    if (benar) score++;
    notifyListeners();
    return benar;
  }

  void lanjut() {
    if (currentIndex + 1 >= soalList.length) {
      isFinished = true;
    } else {
      currentIndex++;
      answered = false;
      dipilih = null;
    }
    notifyListeners();
  }

  void reset() {
    soalList.clear();
    currentIndex = 0;
    score = 0;
    isFinished = false;
    answered = false;
    dipilih = null;
    notifyListeners();
  }
}

/// ===== ThemeProvider — PRD D.3 =====
class ThemeProvider extends ChangeNotifier {
  static const _kDark = 'is_dark_mode';
  bool isDarkMode = false;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    isDarkMode = p.getBool(_kDark) ?? false;
  }

  Future<void> toggle() async {
    isDarkMode = !isDarkMode;
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kDark, isDarkMode);
    notifyListeners();
  }
}
