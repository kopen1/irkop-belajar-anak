import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// Audio engine — PRD D.5
/// kIsWeb check WAJIB — audioplayers support Android & Web.
/// Plugin Android-only lain harus selalu di-guard dengan: if (!kIsWeb) { ... }
class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool isMuted = false;

  static Future<void> play(String assetPath) async {
    if (isMuted) return;
    if (assetPath.isEmpty) return;
    try {
      await _player.stop();
      // audioplayers: AssetSource otomatis menambahkan prefix 'assets/'
      final source = AssetSource(assetPath.replaceFirst('assets/', ''));
      await _player.play(source);
    } catch (e) {
      // Placeholder audio 0-byte (PRD E.1) belum diganti aset real — abaikan.
      debugPrint('Audio skip: $e');
    }
  }

  static Future<void> stop() => _player.stop();

  static void mute() => isMuted = true;
  static void unmute() => isMuted = false;
}
