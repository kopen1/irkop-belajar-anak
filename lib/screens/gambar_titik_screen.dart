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
      _puzzleIdx = idx;
      _playing = true;
      _connected = [];
      _animLineFrom = -1;
      _animProgress = 1.0;
      _completed = false;
      _wrongTap = false;
    });
    _speakNext();
  }

  void _speakNext() {
    if (_isDone) return;
    AudioService.speak('Tap ${_pz.labels[_nextDot]}');
  }

  void _tapDot(int idx) {
    if (_completed || _wrongTap) return;
    if (idx != _nextDot) {
      _wrongTap = true;
      _wrongAnim.forward(from: 0).then((_) {
        if (mounted) setState(() => _wrongTap = false);
      });
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
    AudioService.speak(_pz.labels[idx]);
    if (_isDone) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() => _completed = true);
        AudioService.playSfx('yay');
        AudioService.speak('Yee kamu berhasil! ${_pz.completedText}');
        _saveProgress();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 350), _speakNext);
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'titik_${_mode}_$_puzzleIdx';
    if (!(prefs.getBool(key) ?? false)) await prefs.setBool(key, true);
  }

  @override
  void dispose() {
    _lineAnim.removeListener(_onLineAnim);
    _lineAnim.dispose();
    _pulseAnim.dispose();
    _wrongAnim.dispose();
    super.dispose();
  }

  Offset _toPixel(Offset p, double w, double h) {
    return Offset(p.dx * w, p.dy * h);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(child: _playing ? _gameView() : _levelView()),
    );
  }

  Widget _appBar(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1B4B), size: 28),
            onPressed: _playing
                ? () => setState(() => _playing = false)
                : () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(title,
                style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1B4B))),
          ),
          IconButton(
            icon: Icon(
              AudioService.isMuted ? Icons.volume_off : Icons.volume_up,
              color: const Color(0xFF1E1B4B),
              size: 28,
            ),
            onPressed: () {
              AudioService.toggleMute();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  // ── Level Select ──
  Widget _levelView() {
    return Column(
      children: [
        _appBar('Gambar Titik'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                _modeBtn('Angka', 'angka', const Color(0xFF3B82F6)),
                _modeBtn('Huruf', 'huruf', const Color(0xFF7C3AED)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.9,
            ),
            itemCount: _list.length,
            itemBuilder: (c, i) => _levelCard(i),
          ),
        ),
      ],
    );
  }

  Widget _modeBtn(String label, String mode, Color color) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _mode = mode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: _mode == mode ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _mode == mode ? Colors.white : const Color(0xFF1E1B4B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _levelCard(int i) {
    final pz = _list[i];
    return FutureBuilder<bool>(
      future: SharedPreferences.getInstance()
          .then((p) => p.getBool('titik_${_mode}_$i') ?? false),
      builder: (c, snap) {
        final done = snap.data ?? false;
        return GestureDetector(
          onTap: () => _startPuzzle(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: done ? const Color(0xFF22C55E) : Colors.grey.withOpacity(0.15),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: CustomPaint(painter: _MiniPainter(pz.points, pz.color)),
                ),
                const SizedBox(height: 8),
                Text(pz.nama,
                    style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1B4B))),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (s) => Icon(Icons.star_rounded,
                      size: 16,
                      color: s < pz.difficulty
                          ? const Color(0xFFF59E0B)
                          : Colors.grey.withOpacity(0.25))),
                if (done) ...[
                  const SizedBox(height: 4),
                  const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 20),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Game View ──
  Widget _gameView() {
    if (_completed) return _completeView();
    final labels = _pz.labels;
    return Column(
      children: [
        _appBar(_pz.nama),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: _connected.length / _pz.points.length,
                backgroundColor: Colors.grey.withOpacity(0.15),
                color: _pz.color,
                borderRadius: BorderRadius.circular(5),
                minHeight: 8,
              ),
              const SizedBox(height: 6),
              Text('${_connected.length}/${_pz.points.length} titik',
                  style: GoogleFonts.nunito(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ),
        const Spacer(),
        AnimatedBuilder(
          animation: _wrongAnim,
          builder: (c, ch) {
            final dx = _wrongTap
                ? sin(_wrongAnim.value * 6 * pi) * 6 * (1 - _wrongAnim.value)
                : 0.0;
            return Transform.translate(offset: Offset(dx, 0), child: ch);
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (_, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(w, h),
                      painter: _LinesPainter(
                        _pz.points,
                        _connected,
                        _animLineFrom,
                        _animProgress,
                        _pz.color,
                        w,
                        h,
                      ),
                    ),
                    for (int i = 0; i < _pz.points.length; i++) _buildDot(i, w, h),
                  ],
                );
              },
            ),
          ),
        ),
        const Spacer(),
        if (!_completed)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('Tap ${labels[_nextDot]}',
                style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _pz.color)),
      ],
    );
  }

  Widget _buildDot(int i, double w, double h) {
    final p = _pz.points[i];
    final pos = _toPixel(p, w, h);
    final isNext = i == _nextDot && !_completed;
    final isConnected = _connected.contains(i);
    final r = 20.0;
    return Positioned(
      left: pos.dx - r,
      top: pos.dy - r,
      child: GestureDetector(
        onTap: () => _tapDot(i),
        child: AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, ch) => Transform.scale(
            scale: isNext ? 1.0 + _pulseAnim.value * 0.18 : 1.0,
            child: ch,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: r * 2,
            height: r * 2,
            decoration: BoxDecoration(
              color: isNext
                  ? Colors.amber
                  : (isConnected ? _pz.color : Colors.white),
              shape: BoxShape.circle,
              border: Border.all(color: _pz.color, width: 2.5),
              boxShadow: isNext
                  ? [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 14)]
                  : [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
            ),
            child: Center(
              child: Text(labels[i],
                  style: GoogleFonts.nunito(
                      fontSize: isConnected ? 14 : 18,
                      fontWeight: FontWeight.w800,
                      color: isConnected
                          ? Colors.white
                          : const Color(0xFF1E1B4B))),
            ),
          ),
        ),
      ),
    );
  }

  // ── Complete View ──
  Widget _completeView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_pz.nama,
                style: GoogleFonts.nunito(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: _pz.color)),
            const SizedBox(height: 8),
            Text(_pz.completedText,
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: _pz.color.withOpacity(0.2), blurRadius: 16)
                  ],
                ),
                child: LayoutBuilder(
                  builder: (_, c) => CustomPaint(
                    painter: _CompletePainter(
                        _pz.points, _pz.color, c.maxWidth, c.maxHeight),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Icon(Icons.star_rounded,
                  size: 56,
                  color: i < _pz.difficulty
                      ? const Color(0xFFF59E0B)
                      : Colors.grey.withOpacity(0.3))),
            ),
            const SizedBox(height: 36),
            _bigBtn('Level Selanjutnya', _pz.color, Icons.arrow_forward, () {
              if (_puzzleIdx < _list.length - 1)
                _startPuzzle(_puzzleIdx + 1);
              else
                setState(() => _playing = false);
            }),
            const SizedBox(height: 12),
            _bigBtn('Kembali', Colors.grey[400]!, Icons.home,
                () => setState(() => _playing = false)),
          ],
        ),
      ),
    );
  }

  Widget _bigBtn(String l, Color c, IconData i, VoidCallback f) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: f,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: c.withOpacity(0.3), blurRadius: 12)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(i, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(l,
                  style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Painters ──

class _LinesPainter extends CustomPainter {
  final List<Offset> pts;
  final List<int> conn;
  final int animFrom;
  final double animProg;
  final Color color;
  final double w, h;
  _LinesPainter(this.pts, this.conn, this.animFrom, this.animProg, this.color, this.w, this.h);

  @override
  void paint(Canvas c, Size _) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < conn.length - 1; i++) {
      c.drawLine(_p(conn[i]), _p(conn[i + 1]), paint);
    }
    if (animFrom >= 0 && animFrom < pts.length - 1 && animProg < 1.0 && conn.isNotEmpty) {
      final from = _p(conn.last);
      final to = _p(conn.last + 1);
      final cur = Offset(
        from.dx + (to.dx - from.dx) * animProg,
        from.dy + (to.dy - from.dy) * animProg,
      );
      c.drawLine(from, cur, paint);
    }
  }

  Offset _p(int i) => _toPixel(pts[i], w, h);

  @override
  bool shouldRepaint(_) => true;
}

class _MiniPainter extends CustomPainter {
  final List<Offset> pts;
  final Color color;
  _MiniPainter(this.pts, this.color);

  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < pts.length - 1; i++) {
      c.drawLine(_tp(pts[i], s), _tp(pts[i + 1], s), p);
    }
    c.drawLine(_tp(pts.last, s), _tp(pts.first, s), p);
    for (final pt in pts) {
      c.drawCircle(_tp(pt, s), 4, Paint()..color = color);
    }
  }

  Offset _tp(Offset p, Size s) => Offset(p.dx * s.width, p.dy * s.height);

  @override
  bool shouldRepaint(_) => false;
}

class _CompletePainter extends CustomPainter {
  final List<Offset> pts;
  final Color color;
  final double w, h;
  _CompletePainter(this.pts, this.color, this.w, this.h);

  @override
  void paint(Canvas c, Size _) {
    final path = Path()..moveTo(_p(pts[0]).dx, _p(pts[0]).dy);
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(_p(pts[i]).dx, _p(pts[i]).dy);
    }
    path.close();
    c.drawPath(path, Paint()..color = color.withOpacity(0.12));
    c.drawPath(path, Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);
    for (final pt in pts) {
      c.drawCircle(_p(pt), 8, Paint()..color = color);
      c.drawCircle(_p(pt), 4, Paint()..color = Colors.white);
    }
  }

  Offset _p(Offset pt) => Offset(pt.dx * w, pt.dy * h);

  @override
  bool shouldRepaint(_) => false;
}
