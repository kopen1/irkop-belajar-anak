/// Web TTS via global JS function di index.html.
/// Menggunakan dart:js (bukan dart:js_interop) karena lebih stabil di Flutter 3.24.0.
import 'dart:js' as js;

void speak(String text) {
  try {
    js.context.callMethod('speakTTS', [text]);
  } catch (_) {}
}

void stop() {
  try {
    js.context.callMethod('stopTTS', []);
  } catch (_) {}
}
