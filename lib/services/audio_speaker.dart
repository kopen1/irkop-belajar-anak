import 'package:flutter_tts/flutter_tts.dart';

FlutterTts? _tts;
bool _inited = false;

void _ensureInit() {
  if (_inited) return;
  _inited = true;
  _tts = FlutterTts();
  _tts!.setLanguage('id-ID');
  _tts!.setSpeechRate(0.85);
  _tts!.setPitch(1.15);
}

void speak(String text) {
  if (text.isEmpty) return;
  _ensureInit();
  _tts!.speak(text);
}

/// SFX di APK: pakai TTS dengan pitch/rate berbeda agar terdengar beda.
void playSfx(String type) {
  _ensureInit();
  switch (type) {
    case 'benar':
      _tts!.setPitch(1.5); _tts!.setSpeechRate(0.5);
      _tts!.speak('Hore!');
      _reset();
    case 'salah':
      _tts!.setPitch(0.7); _tts!.setSpeechRate(0.9);
      _tts!.speak('Coba lagi');
      _reset();
    case 'yay':
      _tts!.setPitch(1.6); _tts!.setSpeechRate(0.4);
      _tts!.speak('Selamat luar biasa!');
      _reset();
    case 'klik':
      _tts!.setPitch(1.3); _tts!.setSpeechRate(0.3);
      _tts!.speak('tik');
      _reset();
    default: break;
  }
}

void _reset() {
  Future.delayed(const Duration(milliseconds: 600), () {
    _tts?.setPitch(1.15);
    _tts?.setSpeechRate(0.85);
  });
}

void stop() => _tts?.stop();
