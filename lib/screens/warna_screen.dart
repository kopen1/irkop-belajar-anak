import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_service.dart';

class WarnaScreen extends StatefulWidget {
  const WarnaScreen({super.key});
  @override
  State<WarnaScreen> createState() => _WarnaScreenState();
}

class _WarnaScreenState extends State<WarnaScreen>
    with TickerProviderStateMixin {
  late TabController _tabCtrl;

  // Mini game state
  int _gameRound = 0;
  int _gameScore = 0;
  int _targetIdx = 0;
  bool _answered = false;
  int? _selected;
  bool _isCorrect = false;
  bool _showGameResult = false;
  late AnimationController _bounceCtrl;
  late AnimationController _shakeCtrl;

  final _warnaData = [
    ('Merah', 0xFFEF4444), ('Biru', 0xFF3B82F6), ('Kuning', 0xFFEAB308),
    ('Hijau', 0xFF22C55E), ('Oranye', 0xFFF97316), ('Ungu', 0xFF7C3AED),
    ('Pink', 0xFFEC4899), ('Coklat', 0xFF92400E), ('Hitam', 0xFF1F2937),
    ('Putih', 0xFFF9FAFB), ('Abu-abu', 0xFF9CA3AF), ('Emas', 0xFFD97706),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  void _startGame() {
    setState(() { _gameRound = 0; _gameScore = 0; _showGameResult = false; _nextRound(); });
  }

  void _nextRound() {
    final rng = Random();
    setState(() {
      _targetIdx = rng.nextInt(_warnaData.length);
      _answered = false;
      _selected = null;
      _isCorrect = false;
    });
    final (nama, _) = _warnaData[_targetIdx];
    AudioService.speak('Warna apa ini?');
  }

  List<int> _generateOptions() {
    final opts = <int>{_targetIdx};
    final rng = Random();
    while (opts.length < 4) { opts.add(rng.nextInt(_warnaData.length)); }
    return opts.toList()..shuffle();
  }

  void _selectGameAnswer(int idx) {
    if (_answered) return;
    final correct = idx == _targetIdx;
    setState(() { _answered = true; _selected = idx; _isCorrect = correct; });
    if (correct) {
      _gameScore++;
      _bounceCtrl.forward(from: 0);
      final (nama, _) = _warnaData[_targetIdx];
      AudioService.speak('Benar! Warna $nama');
    } else {
      _shakeCtrl.forward(from: 0);
      AudioService.speak('Coba lagi!');
    }
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (_gameRound < 9) { setState(() => _gameRound++); _nextRound(); }
      else { setState(() => _showGameResult = true); AudioService.speak('Selamat!'); }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose(); _bounceCtrl.dispose(); _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [_buildBelajarTab(), _buildGameTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1B4B), size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(child: Text('Warna', style: GoogleFonts.nunito(
            fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)))),
          IconButton(
            icon: Icon(AudioService.isMuted ? Icons.volume_off : Icons.volume_up,
              color: const Color(0xFF1E1B4B), size: 28),
            onPressed: () { AudioService.toggleMute(); setState(() {}); },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
      child: TabBar(
        controller: _tabCtrl,
        indicator: BoxDecoration(color: const Color(0xFFEC4899), borderRadius: BorderRadius.circular(12)),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF1E1B4B),
        labelStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
        tabs: const [Tab(height: 44, text: 'Belajar'), Tab(height: 44, text: 'Bermain')],
      ),
    );
  }

  // ── Tab Belajar ──
  Widget _buildBelajarTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
      itemCount: _warnaData.length,
      itemBuilder: (context, idx) {
        final (nama, hex) = _warnaData[idx];
        final color = Color(hex);
        final isLight = [0xFFEAB308, 0xFFF9FAFB, 0xFF9CA3AF].contains(hex);
        return GestureDetector(
          onTap: () => AudioService.speak('ini warna $nama'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                ),
                const SizedBox(height: 8),
                Text(nama, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700,
                  color: isLight ? const Color(0xFF1E1B4B) : Colors.white)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Tab Bermain ──
  Widget _buildGameTab() {
    if (_showGameResult) return _buildGameResult();
    if (_gameRound == 0 && !_answered) return _buildGameStart();
    return _buildGamePlay();
  }

  Widget _buildGameStart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 120, height: 120,
            decoration: BoxDecoration(color: const Color(0xFFEC4899).withOpacity(0.12), shape: BoxShape.circle),
            child: const Icon(Icons.palette, size: 56, color: Color(0xFFEC4899))),
          const SizedBox(height: 24),
          Text('Tebak Warna!', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B))),
          const SizedBox(height: 8),
          Text('Lihat warnanya lalu\ntap nama yang benar!', style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          _bigBtn('Mulai Bermain', const Color(0xFFEC4899), Icons.play_arrow, _startGame),
        ]),
      ),
    );
  }

  Widget _buildGamePlay() {
    final (targetName, targetHex) = _warnaData[_targetIdx];
    final targetColor = Color(targetHex);
    final options = _generateOptions();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text('Ronde ${_gameRound + 1}/10', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: (_gameRound + 1) / 10, backgroundColor: Colors.grey.withOpacity(0.15),
            color: const Color(0xFFEC4899), borderRadius: BorderRadius.circular(5), minHeight: 8),
          const Spacer(flex: 1),

          // Warna display — immersive background
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: targetColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: targetColor.withOpacity(0.3), width: 2),
            ),
            child: AnimatedBuilder(
              animation: _bounceCtrl,
              builder: (c, child) => Transform.scale(
                scale: _isCorrect && _answered ? 1 + _bounceCtrl.value * 0.12 : 1.0, child: child),
              child: AnimatedBuilder(
                animation: _shakeCtrl,
                builder: (c, child) => Transform.translate(
                  offset: Offset(!_isCorrect && _answered ? sin(_shakeCtrl.value * 6 * pi) * 8 * (1 - _shakeCtrl.value) : 0, 0),
                  child: child,
                ),
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(color: targetColor, shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: targetColor.withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 8))]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Warna apa ini?', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
          const Spacer(flex: 1),

          // Opsi dengan preview warna
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.8,
            children: options.map((idx) {
              final (nama, hex) = _warnaData[idx];
              final sel = _selected == idx;
              final cor = idx == _targetIdx;
              Color bg = Colors.white, tc = const Color(0xFF1E1B4B);
              Color bc = const Color(0xFFEC4899).withOpacity(0.3);
              if (_answered) {
                if (cor) { bg = const Color(0xFF22C55E); tc = Colors.white; bc = const Color(0xFF22C55E); }
                else if (sel) { bg = const Color(0xFFEF4444); tc = Colors.white; bc = const Color(0xFFEF4444); }
                else { bg = Colors.grey.withOpacity(0.1); tc = Colors.grey; bc = Colors.transparent; }
              }
              return AnimatedContainer(duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: bc, width: 2)),
                child: Material(color: Colors.transparent, child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _answered ? null : () => _selectGameAnswer(idx),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(width: 22, height: 22, decoration: BoxDecoration(
                      color: Color(hex), shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2))),
                    const SizedBox(width: 10),
                    Flexible(child: Text(nama, style: GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w700, color: tc),
                      overflow: TextOverflow.ellipsis)),
                  ]),
                )),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.star, color: Color(0xFFF59E0B), size: 20),
            const SizedBox(width: 4),
            Text('Skor: $_gameScore', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
          ]),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildGameResult() {
    final stars = _gameScore >= 8 ? 3 : _gameScore >= 5 ? 2 : 1;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Selamat!', style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w800, color: const Color(0xFFEC4899))),
          const SizedBox(height: 8),
          Text('Permainan selesai', style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 28),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => Icon(
            Icons.star_rounded, size: 56,
            color: i < stars ? const Color(0xFFF59E0B) : Colors.grey.withOpacity(0.3)))),
          const SizedBox(height: 28),
          Container(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
            child: Text('Skor: $_gameScore dari 10', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B))),
          ),
          const SizedBox(height: 36),
          _bigBtn('Main Lagi', const Color(0xFFEC4899), Icons.refresh, _startGame),
          const SizedBox(height: 12),
          _bigBtn('Kembali', Colors.grey[400]!, Icons.home, () => _tabCtrl.animateTo(0)),
        ]),
      ),
    );
  }

  Widget _bigBtn(String label, Color color, IconData icon, VoidCallback onTap) {
    return Material(color: Colors.transparent, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20),
      child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12)]),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 24), const SizedBox(width: 8),
          Text(label, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      ),
    ));
  }
}
