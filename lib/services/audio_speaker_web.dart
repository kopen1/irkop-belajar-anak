import 'dart:js_interop';

@JS('SpeechSynthesisUtterance')
extension type _Utterance._(JSObject _) implements JSObject {
  external factory _Utterance(String text);
  external set rate(num r);
  external set pitch(num p);
  external set lang(String l);
}

extension type _Synth._(JSObject _) implements JSObject {
  external void speak(_Utterance u);
  external void cancel();
}

@JS('window.speechSynthesis')
external _Synth get _synth;

void speak(String text) {
  if (text.isEmpty) return;
  _synth.cancel();
  final u = _Utterance(text)
    ..rate = 0.85
    ..pitch = 1.15
    ..lang = 'id-ID';
  _synth.speak(u);
}

/// Hentikan speech yang sedang berjalan.
void stop() {
  _synth.cancel();
}
