import 'package:flutter/foundation.dart';
import 'audio_speaker.dart' if (dart.library.js_interop) 'audio_speaker_web.dart' as speaker;

class AudioService {
  static bool isMuted = false;

  static Future<void> play(String assetPath, {String? ttsText}) async {
    if (isMuted) return;
    final text = ttsText ?? _assetToText(assetPath);
    if (text.isEmpty) return;
    speaker.speak(text);
  }

  static Future<void> speak(String text) async {
    if (isMuted || text.isEmpty) return;
    speaker.speak(text);
  }

  static Future<void> playSfx(String sfxName) async {
    if (isMuted) return;
    final messages = <String, String>{
      'benar': 'Hebat! Jawaban benar!',
      'salah': 'Coba lagi ya!',
      'yay': 'Selamat! Luar biasa!',
      'klik': '',
    };
    final msg = messages[sfxName];
    if (msg != null && msg.isNotEmpty) speaker.speak(msg);
  }

  /// Stop semua audio yang sedang diputar.
  static Future<void> stop() async {
    speaker.stop();
  }

  static void mute() => isMuted = true;
  static void unmute() => isMuted = false;
  static void toggleMute() => isMuted = !isMuted;

  static String _assetToText(String path) {
    if (path.contains('audio/huruf/')) {
      return path.split('/').last.replaceAll('.mp3', '').toUpperCase();
    }
    if (path.contains('audio/angka/')) {
      final n = int.tryParse(path.split('/').last.replaceAll('.mp3', ''));
      const words = [
        '', 'satu', 'dua', 'tiga', 'empat', 'lima',
        'enam', 'tujuh', 'delapan', 'sembilan', 'sepuluh'
      ];
      if (n != null && n >= 1 && n <= 10) return words[n];
    }
    if (path.contains('audio/warna/')) {
      return 'ini warna ${path.split('/').last.replaceAll('.mp3', '')}';
    }
    if (path.contains('audio/hewan/')) {
      return path.split('/').last.replaceAll('.mp3', '');
    }
    return '';
  }
}
