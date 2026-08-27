cd ~/workspace/projects/irkop-belajar-anak

cat > fix/fix_v5.sh << 'MAINSCRIPT'
#!/usr/bin/env bash
set -e

echo "🔧 1/5: flutter_tts downgrade 3.8.6 (kompat Kotlin 1.9)"
sed -i 's/flutter_tts:.*$/flutter_tts: 3.8.6/' pubspec.yaml

echo "🔧 2/5: Kotlin 1.9.22 + compileSdk 35"
sed -i "s/kotlin_version = \"[^\"]*\"/kotlin_version = \"1.9.22\"/" android/build.gradle
sed -i 's/compileSdk [0-9]*/compileSdk 35/' android/app/build.gradle

echo "🔧 3/5: update workflow compileSdk sed"
sed -i 's/compileSdk 34/compileSdk 35/' .github/workflows/build.yml

echo "🔧 4/5: gambar_titik_data.dart"
cat > lib/data/gambar_titik_data.dart << 'ENDDART'
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
ENDDART

echo "🔧 5/5: gambar_titik_screen.dart"
cat > lib/screens/gambar_titik_screen.dart << 'ENDDART'
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/gambar_titik_data.dart';
import '../services/audio_service.dart';

class GambarTitikScreen extends StatefulWidget {
  const GambarTitikScreen({super.key});
  @override
  State<GambarTitikScreen> createState() => _GambarTitikScreenState();
}

class _GambarTitikScreenState extends State<GambarTitikScreen>
    with TickerProviderStateMixin {
  String _mode = 'angka';
  bool _playing = false;
  int _puzzleIdx = 0;
  List<int> _connected = [];
  int _animLineFrom = -1;
  double _animProgress = 1.0;
  bool _completed = false;
  bool _wrongTap = false;
  late AnimationController _lineAnim, _pulseAnim, _wrongAnim;

  List<TitikPuzzle> get _list => getPuzzles(_mode);
  TitikPuzzle get _pz => _list[_puzzleIdx];
  int get _nextDot => _connected.isEmpty ? 0 : _connected.last + 1;
  bool get _isDone => _connected.length == _pz.points.length;

  @override
  void initState() {
    super.initState();
    _lineAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _pulseAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _wrongAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _lineAnim.addListener(_onLineAnim);
  }

  void _onLineAnim() {
    if (!_lineAnim.isAnimating && _animProgress >= 1.0) return;
    setState(() => _animProgress = _lineAnim.value);
  }

  void _startPuzzle(int idx) {
    setState(() {
      _puzzleIdx = idx; _playing = true;
      _connected = []; _animLineFrom = -1; _animProgress = 1.0;
      _completed = false; _wrongTap = false;
    });
    _speakNext();
  }

  void _speakNext() {
    if (_isDone) return;
    final labels = _pz.labels;
    AudioService.speak('Tap ${labels[_nextDot]}');
  }

  void _tapDot(int idx) {
    if (_completed || _wrongTap) return;
    if (idx != _nextDot) {
      _wrongTap = true;
      _wrongAnim.forward(from: 0).then((_) { if (mounted) setState(() => _wrongTap = false); });
      AudioService.playSfx('salah');
      AudioService.speak('Coba lagi');
      return;
    }

    if (_connected.isNotEmpty) {
      _animLineFrom = _connected.last;
      _animProgress = 0;
      _lineAnim.forward(from: 0);
    }
    setState(() => _connected.add(idx));
    AudioService.playSfx('klik');

    final labels = _pz.labels;
    AudioService.speak(labels[idx]);

    if (_isDone) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() => _completed = true);
        AudioService.playSfx('yay');
        AudioService.speak('Yee! Kamu berhasil! ${_pz.completedText}');
        _saveProgress();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 350), _speakNext);
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'titik_${_mode}_${_puzzleIdx}';
    if (!(prefs.getBool(key) ?? false)) await prefs.setBool(key, true);
  }

  @override
  void dispose() {
    _lineAnim.removeListener(_onLineAnim);
    _lineAnim.dispose(); _pulseAnim.dispose(); _wrongAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F3FF), body: SafeArea(child: _playing ? _gameView() : _levelView()));
  }

  // ── Level Select ──
  Widget _levelView() => Column(children: [
    _appBar('Gambar Titik'),
    // Mode toggle
    Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
      child: Row(children: [
        _modeBtn('Angka', 'angka', const Color(0xFF3B82F6)),
        _modeBtn('Huruf', 'huruf', const Color(0xFF7C3AED)),
      ]))),
    const SizedBox(height: 12),
    Expanded(child: GridView.builder(padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.9),
      itemCount: _list.length,
      itemBuilder: (c, i) => _levelCard(i))),
  ]);

  Widget _modeBtn(String label, String mode, Color color) => Expanded(
    child: Material(color: Colors.transparent, child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () { setState(() => _mode = mode); },
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: _mode == mode ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(14)),
        alignment: Alignment.center,
        child: Text(label, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700,
          color: _mode == mode ? Colors.white : const Color(0xFF1E1B4B)))))));

  Widget _levelCard(int i) {
    final pz = _list[i];
    return FutureBuilder<bool>(future: SharedPreferences.getInstance().then((p) => p.getBool('titik_${_mode}_$i') ?? false),
      builder: (c, snap) {
        final done = snap.data ?? false;
        return GestureDetector(onTap: () => _startPuzzle(i), child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: done ? const Color(0xFF22C55E) : Colors.grey.withOpacity(0.15), width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
          padding: const EdgeInsets.all(14),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Mini preview
            SizedBox(height: 80, width: double.infinity, child: CustomPaint(
              painter: _MiniPainter(pz.points, pz.color))),
            const SizedBox(height: 8),
            Text(pz.nama, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (s) => Icon(
              Icons.star_rounded, size: 16, color: s < pz.difficulty ? const Color(0xFFF59E0B) : Colors.grey.withOpacity(0.25)))),
            if (done) ...[
              const SizedBox(height: 4),
              const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20),
            ],
          ])));
      });
  }

  // ── Game View ──
  Widget _gameView() {
    if (_completed) return _completeView();
    final labels = _pz.labels;
    return Column(children: [
      _appBar(_pz.nama),
      // Progress
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: [
        LinearProgressIndicator(value: _connected.length / _pz.points.length,
          backgroundColor: Colors.grey.withOpacity(0.15), color: _pz.color, borderRadius: BorderRadius.circular(5), minHeight: 8),
        const SizedBox(height: 6),
        Text('${_connected.length}/${_pz.points.length} titik', style: GoogleFonts.nunito(fontSize: 13, color: Colors.grey[600])),
      ])),
      const Spacer(),
      // Game area
      AnimatedBuilder(animation: _wrongAnim, builder: (c, ch) => Transform.translate(
        offset: Offset(_wrongTap ? sin(_wrongAnim.value * 6 * pi) * 6 * (1 - _wrongAnim.value) : 0, 0), child: ch),
        child: AspectRatio(aspectRatio: 1, child: LayoutBuilder(builder: (c, _) {
          final w = c.maxWidth; final h = c.maxHeight;
          return Stack(children: [
            // Lines
            CustomPaint(size: Size(w, h),
              painter: _LinesPainter(_pz.points, _connected, _animLineFrom, _animProgress, _pz.color)),
            // Dots
            ...List.generate(_pz.points.length, (i) {
              final p = _pz.points[i];
              final isNext = i == _nextDot && !_completed;
              final isConnected = _connected.contains(i);
              final r = 20.0;
              return Positioned(
                left: p.dx * w - r, top: p.dy * h - r,
                child: GestureDetector(onTap: () => _tapDot(i), child: AnimatedBuilder(
                  animation: _pulseAnim, builder: (c, ch) => Transform.scale(
                    scale: isNext ? 1.0 + _pulseAnim.value * 0.18 : 1.0, child: ch)),
                  child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                    width: r * 2, height: r * 2,
                    decoration: BoxDecoration(
                      color: isNext ? Colors.amber : (isConnected ? _pz.color : Colors.white),
                      shape: BoxShape.circle,
                      border: Border.all(color: _pz.color, width: 2.5),
                      boxShadow: isNext
                        ? [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 14)]
                        : [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Center(child: Text(labels[i], style: GoogleFonts.nunito(
                      fontSize: isConnected ? 14 : 18, fontWeight: FontWeight.w800,
                      color: isConnected ? Colors.white : const Color(0xFF1E1B4B))))),
                )),
              );
            }),
          ]);
        })),
      ),
      const Spacer(),
      // Hint
      if (!_completed)
        Padding(padding: const EdgeInsets.only(bottom: 20),
          child: Text('Tap ${labels[_nextDot]}', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: _pz.color))),
    ]);
  }

  // ── Complete View ──
  Widget _completeView() {
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(_pz.nama, style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w800, color: _pz.color)),
      const SizedBox(height: 8),
      Text(_pz.completedText, style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
      const SizedBox(height: 24),
      // Preview completed shape
      AspectRatio(aspectRatio: 1, child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: _pz.color.withOpacity(0.2), blurRadius: 16)]),
        child: CustomPaint(painter: _CompletePainter(_pz.points, _pz.color)))),
      const SizedBox(height: 24),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => Icon(
        Icons.star_rounded, size: 56, color: i < _pz.difficulty ? const Color(0xFFF59E0B) : Colors.grey.withOpacity(0.3)))),
      const SizedBox(height: 36),
      _bigBtn('Level Selanjutnya', _pz.color, Icons.arrow_forward, () {
        if (_puzzleIdx < _list.length - 1) _startPuzzle(_puzzleIdx + 1);
        else setState(() => _playing = false);
      }),
      const SizedBox(height: 12),
      _bigBtn('Kembali', Colors.grey[400]!, Icons.home, () => setState(() => _playing = false)),
    ])));
  }

  Widget _appBar(String title) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [
    IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1B4B), size: 28),
      onPressed: _playing ? () => setState(() => _playing = false) : () => Navigator.of(context).pop()),
    Expanded(child: Text(title, style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)))),
    IconButton(icon: Icon(AudioService.isMuted ? Icons.volume_off : Icons.volume_up, color: const Color(0xFF1E1B4B), size: 28),
      onPressed: () { AudioService.toggleMute(); setState(() {}); }),
  ]));

  Widget _bigBtn(String l, Color c, IconData i, VoidCallback f) => Material(color: Colors.transparent,
    child: InkWell(onTap: f, borderRadius: BorderRadius.circular(20),
      child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: c.withOpacity(0.3), blurRadius: 12)]),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(i, color: Colors.white, size: 24), const SizedBox(width: 8),
          Text(l, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        ]))));
}

// ── Painters ──

class _LinesPainter extends CustomPainter {
  final List<Offset> pts;
  final List<int> conn;
  final int animFrom;
  final double animProg;
  final Color color;
  _LinesPainter(this.pts, this.conn, this.animFrom, this.animProg, this.color);

  @override
  void paint(Canvas c, Size s) {
    final paint = Paint()..color = color..strokeWidth = 4..strokeCap = StrokeCap.round;
    // Completed lines
    for (int i = 0; i < conn.length - 1; i++) {
      c.drawLine(pts[conn[i]] * s, pts[conn[i + 1]] * s, paint);
    }
    // Animating line
    if (animFrom >= 0 && animFrom < pts.length - 1 && animProg < 1.0 && conn.isNotEmpty) {
      final from = pts[conn.last] * s;
      final to = pts[conn.last + 1] * s;
      final cur = Offset(from.dx + (to.dx - from.dx) * animProg, from.dy + (to.dy - from.dy) * animProg);
      c.drawLine(from, cur, paint);
    }
  }
  @override
  bool shouldRepaint(_) => true;
}

class _MiniPainter extends CustomPainter {
  final List<Offset> pts;
  final Color color;
  _MiniPainter(this.pts, this.color);

  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = color..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < pts.length - 1; i++) c.drawLine(pts[i] * s, pts[i + 1] * s, p);
    c.drawLine(pts.last * s, pts.first * s, p);
    for (final pt in pts) {
      c.drawCircle(pt * s, 4, Paint()..color = color);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _CompletePainter extends CustomPainter {
  final List<Offset> pts;
  final Color color;
  _CompletePainter(this.pts, this.color);

  @override
  void paint(Canvas c, Size s) {
    // Fill
    final fill = Paint()..color = color.withOpacity(0.12);
    final path = Path()..moveTo(pts[0].dx * s.width, pts[0].dy * s.height);
    for (int i = 1; i < pts.length; i++) path.lineTo(pts[i].dx * s.width, pts[i].dy * s.height);
    path.close();
    c.drawPath(path, fill);
    // Stroke
    final stroke = Paint()..color = color..strokeWidth = 4..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    c.drawPath(path, stroke);
    // Dots
    for (final pt in pts) {
      c.drawCircle(pt * s, 8, Paint()..color = color);
      c.drawCircle(pt * s, 4, Paint()..color = Colors.white);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}
ENDDART

echo ""
echo "✅ Semua fix v5 diterapkan!"
echo "📌 Ringkasan:"
echo "   1. flutter_tts 4.2.5 → 3.8.6 (fix Kotlin 2.2 conflict)"
echo "   2. Kotlin → 1.9.22 (Flutter 3.24.0 default)"
echo "   3. compileSdk → 35 (robust sed)"
echo "   4. Game Gambar Titik: 8 bentuk × 2 mode (Angka + Huruf)"
echo "      Garis, Segitiga, Kotak, Berlian, Bintang, Panah, Rumah, Hati"
echo "   5. Fitur: animasi garis, dot berkedip, SFX, TTS, progress save"
echo ""
echo "⚠️  TODO MANUAL: Tambahkan menu Gambar Titik di home_screen.dart"
echo "   Tambahkan item menu ini di grid home screen:"
echo "   _menuCard(Icons.draw, 'Gambar Titik', () => context.push('/gambar-titik')),"
echo "   Dan route: GoRoute(path: '/gambar-titik', builder: (_,__) => GambarTitikScreen()),"
echo ""
echo "⏳ Commit & push..."
git add -A
git commit -m "fix: flutter_tts 3.8.6 kotlin 1.9.22, add gambar titik game"
git push
echo ""
echo "🎉 Done!"
MAINSCRIPT

chmod +x fix/fix_v5.sh
echo "bash fix/fix_v5.sh"
