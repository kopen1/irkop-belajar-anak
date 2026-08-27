import 'dart:math';
import 'package:flutter/material.dart';

import 'angka_data.dart';
import 'hewan_data.dart';
import 'huruf_data.dart';
import 'warna_data.dart';

/// Model Kuis — PRD D.2
class KuisSoal {
  final String pertanyaan;       // "Ini hewan apa?"
  final String audioPertanyaan;  // opsional (aset menyusul)
  final List<String> opsi;       // 4 pilihan
  final int jawabanIndex;
  final String kategori;         // "hewan" | "huruf" | "angka" | "warna"
  final String emojiVisual;      // huruf / emoji
  final Color? warnaVisual;      // lingkaran warna
  final int? jumlahVisual;       // berapa emoji ditampilkan
  KuisSoal({
    required this.pertanyaan,
    this.audioPertanyaan = '',
    required this.opsi,
    required this.jawabanIndex,
    required this.kategori,
    this.emojiVisual = '',
    this.warnaVisual,
    this.jumlahVisual,
  });
}

final Random _rng = Random();

List<String> _acakOpsi(String benar, Iterable<String> semua) {
  final distraktor = (semua.toList()..shuffle(_rng)).where((e) => e != benar).take(3).toList();
  return [...distraktor, benar]..shuffle(_rng);
}

/// 10 soal per sesi — diacak dari bank soal (PRD B.2.5)
List<KuisSoal> buatSoal(String kategori, int jumlah) {
  switch (kategori) {
    case 'huruf':
      final bank = List.generate(daftarHuruf.length, (i) => i)..shuffle(_rng);
      return bank.take(jumlah).map((i) {
        final h = daftarHuruf[i];
        final tampil = '${h.hurufBesar}${h.hurufKecil}';
        final opsi = _acakOpsi(tampil, daftarHuruf.map((e) => '${e.hurufBesar}${e.hurufKecil}'));
        return KuisSoal(
          pertanyaan: 'Ini huruf apa?',
          opsi: opsi,
          jawabanIndex: opsi.indexOf(tampil),
          kategori: 'huruf',
          emojiVisual: tampil,
        );
      }).toList();
    case 'angka':
      return List.generate(jumlah, (_) {
        final n = 1 + _rng.nextInt(10);
        final a = daftarAngka[n - 1];
        final opsi = _acakOpsi(a.kata, daftarAngka.map((e) => e.kata));
        return KuisSoal(
          pertanyaan: 'Ada berapa benda ini?',
          opsi: opsi,
          jawabanIndex: opsi.indexOf(a.kata),
          kategori: 'angka',
          emojiVisual: a.emoji,
          jumlahVisual: n,
        );
      });
    case 'warna':
      final bank = List.generate(daftarWarna.length, (i) => i)..shuffle(_rng);
      return bank.take(jumlah).map((i) {
        final w = daftarWarna[i];
        final opsi = _acakOpsi(w.nama, daftarWarna.map((e) => e.nama));
        return KuisSoal(
          pertanyaan: 'Ini warna apa?',
          opsi: opsi,
          jawabanIndex: opsi.indexOf(w.nama),
          kategori: 'warna',
          warnaVisual: w.warna,
        );
      }).toList();
    default:
      final bank = List.generate(daftarHewan.length, (i) => i)..shuffle(_rng);
      return bank.take(jumlah).map((i) {
        final h = daftarHewan[i];
        final opsi = _acakOpsi(h.nama, daftarHewan.map((e) => e.nama));
        return KuisSoal(
          pertanyaan: 'Ini hewan apa?',
          opsi: opsi,
          jawabanIndex: opsi.indexOf(h.nama),
          kategori: 'hewan',
          emojiVisual: h.emoji,
        );
      }).toList();
  }
}
