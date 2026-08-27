import 'dart:js' as js;

void speak(String text) {
  try { js.context.callMethod('speakTTS', [text]); } catch (_) {}
}

void playSfx(String type) {
  try {
    switch (type) {
      case 'benar': js.context.callMethod('playCorrectSfx', []);
      case 'salah': js.context.callMethod('playWrongSfx', []);
      case 'yay': js.context.callMethod('playYaySfx', []);
      case 'klik': js.context.callMethod('playClickSfx', []);
    }
  } catch (_) {}
}

void stop() {
  try { js.context.callMethod('stopTTS', []); } catch (_) {}
}
