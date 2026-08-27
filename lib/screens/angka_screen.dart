import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_service.dart';

class AngkaScreen extends StatefulWidget {
  const AngkaScreen({super.key});
  @override
  State<AngkaScreen> createState() => _AngkaScreenState();
}

class _AngkaScreenState extends State<AngkaScreen> with TickerProviderStateMixin {
  late TabController _tabCtrl;
  late PageController _pageCtrl;
  bool _gameStarted = false;
  int _gameRound = 0, _gameScore = 0, _targetNumber = 1;
  bool _answered = false; int? _selected; bool _isCorrect = false, _showGameResult = false;
  late AnimationController _bounceCtrl, _shakeCtrl;

  final _data = [
    (1,'satu','⭐'),(2,'dua','⭐⭐'),(3,'tiga','⭐⭐⭐'),(4,'empat','⭐⭐⭐⭐'),
    (5,'lima','⭐⭐⭐⭐⭐'),(6,'enam','⭐⭐⭐⭐⭐⭐'),(7,'tujuh','⭐⭐⭐⭐⭐⭐⭐'),
    (8,'delapan','⭐⭐⭐⭐⭐⭐⭐⭐'),(9,'sembilan','⭐⭐⭐⭐⭐⭐⭐⭐⭐'),
    (10,'sepuluh','⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐'),
  ];
  final _colors = [
    const Color(0xFF3B82F6),const Color(0xFF8B5CF6),const Color(0xFF06B6D4),
    const Color(0xFF10B981),const Color(0xFFF59E0B),const Color(0xFFEF4444),
    const Color(0xFFEC4899),const Color(0xFF6366F1),const Color(0xFF14B8A6),const Color(0xFFF97316),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _pageCtrl = PageController();
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  void _startGame() {
    setState(() { _gameStarted = true; _gameRound = 0; _gameScore = 0; _showGameResult = false; });
    _nextRound();
  }

  void _nextRound() {
    final rng = Random();
    setState(() { _targetNumber = rng.nextInt(10) + 1; _answered = false; _selected = null; _isCorrect = false; });
    AudioService.speak('Ada berapa bintang?');
  }

  List<int> _genOpts() {
    final s = <int>{_targetNumber}; final rng = Random();
    while (s.length < 4) s.add(rng.nextInt(10) + 1);
    return s.toList()..shuffle();
  }

  void _pick(int n) {
    if (_answered) return;
    final ok = n == _targetNumber;
    setState(() { _answered = true; _selected = n; _isCorrect = ok; });
    if (ok) {
      _gameScore++; _bounceCtrl.forward(from: 0);
      AudioService.playSfx('benar');
      AudioService.speak('Benar! $_targetNumber bintang');
    } else {
      _shakeCtrl.forward(from: 0);
      AudioService.playSfx('salah');
    }
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      if (_gameRound < 9) { setState(() => _gameRound++); _nextRound(); }
      else { setState(() => _showGameResult = true); AudioService.playSfx('yay'); }
    });
  }

  @override
  void dispose() { _tabCtrl.dispose(); _pageCtrl.dispose(); _bounceCtrl.dispose(); _shakeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F3FF), body: SafeArea(child: Column(children: [
      _appBar(), _tabBar(),
      Expanded(child: TabBarView(controller: _tabCtrl, children: [_belajarTab(), _gameTab()])),
    ])));
  }

  Widget _appBar() => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [
    IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1B4B), size: 28), onPressed: () => Navigator.of(context).pop()),
    Expanded(child: Text('Angka', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)))),
    IconButton(icon: Icon(AudioService.isMuted ? Icons.volume_off : Icons.volume_up, color: const Color(0xFF1E1B4B), size: 28),
      onPressed: () { AudioService.toggleMute(); setState(() {}); }),
  ]));

  Widget _tabBar() => Container(margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
    child: TabBar(controller: _tabCtrl,
      indicator: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(12)),
      indicatorSize: TabBarIndicatorSize.tab, indicatorPadding: const EdgeInsets.all(4), dividerColor: Colors.transparent,
      labelColor: Colors.white, unselectedLabelColor: const Color(0xFF1E1B4B),
      labelStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
      tabs: const [Tab(height: 44, text: 'Belajar'), Tab(height: 44, text: 'Bermain')]));

  Widget _belajarTab() => PageView.builder(controller: _pageCtrl, itemCount: 10,
    itemBuilder: (c, i) {
      final (n, t, e) = _data[i]; final col = _colors[i];
      return Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        const Spacer(),
        GestureDetector(onTap: () => AudioService.speak(t), child: Container(width: 200, height: 200,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [col, col.withOpacity(0.7)],
            begin: Alignment.topLeft, end: Alignment.bottomRight), shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: col.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 10))]),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('$n', style: GoogleFonts.nunito(fontSize: 80, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 4), Text(e, style: const TextStyle(fontSize: 16)),
          ]))),
        const SizedBox(height: 32),
        Text(t, style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B))),
        Text('Tap angka untuk mendengar', style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[500])),
        const Spacer(),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (i > 0) _navBtn(Icons.arrow_back, () => _pageCtrl.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)),
          const SizedBox(width: 32), Text('${i+1}/10', style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[500])), const SizedBox(width: 32),
          if (i < 9) _navBtn(Icons.arrow_forward, () => _pageCtrl.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)),
        ]),
        const SizedBox(height: 16),
      ]));
    });

  Widget _navBtn(IconData ic, VoidCallback fn) => Material(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(30),
    child: InkWell(borderRadius: BorderRadius.circular(30), onTap: fn,
      child: Padding(padding: const EdgeInsets.all(12), child: Icon(ic, color: Colors.white, size: 24))));

  Widget _gameTab() {
    if (_showGameResult) return _gameResult();
    if (!_gameStarted) return _gameStart();
    return _gamePlay();
  }

  Widget _gameStart() => Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 120, height: 120, decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.12), shape: BoxShape.circle),
      child: const Icon(Icons.games, size: 56, color: Color(0xFF3B82F6))),
    const SizedBox(height: 24),
    Text('Hitung Bintang!', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B))),
    const SizedBox(height: 8),
    Text('Hitung jumlah bintang\ndan tap jawaban yang benar!', style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
    const SizedBox(height: 40),
    _bigBtn('Mulai Bermain', const Color(0xFF3B82F6), Icons.play_arrow, _startGame),
  ])));

  Widget _gamePlay() {
    final opts = _genOpts();
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: [
      const SizedBox(height: 8),
      Text('Ronde ${_gameRound+1}/10', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
      const SizedBox(height: 4),
      LinearProgressIndicator(value: (_gameRound+1)/10, backgroundColor: Colors.grey.withOpacity(0.15),
        color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(5), minHeight: 8),
      const Spacer(),
      AnimatedBuilder(animation: _bounceCtrl, builder: (c, ch) => Transform.scale(
        scale: _isCorrect && _answered ? 1+_bounceCtrl.value*0.12 : 1.0, child: ch),
        child: AnimatedBuilder(animation: _shakeCtrl, builder: (c, ch) => Transform.translate(
          offset: Offset(!_isCorrect && _answered ? sin(_shakeCtrl.value*6*pi)*8*(1-_shakeCtrl.value) : 0, 0), child: ch),
          child: Container(width: 220, height: 180, margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
            child: Center(child: Text('⭐'*_targetNumber, style: TextStyle(fontSize: _targetNumber<=5?36:24), textAlign: TextAlign.center))))),
      const SizedBox(height: 16),
      Text('Ada berapa bintang?', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
      const Spacer(),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.5,
        children: opts.map((n) {
          final sel = _selected==n, cor = n==_targetNumber;
          Color bg=Colors.white, tc=const Color(0xFF1E1B4B), bc=const Color(0xFF3B82F6).withOpacity(0.3);
          if (_answered) {
            if (cor) { bg=const Color(0xFF22C55E); tc=Colors.white; bc=const Color(0xFF22C55E); }
            else if (sel) { bg=const Color(0xFFEF4444); tc=Colors.white; bc=const Color(0xFFEF4444); }
            else { bg=Colors.grey.withOpacity(0.1); tc=Colors.grey; bc=Colors.transparent; }
          }
          return AnimatedContainer(duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: bc, width: 2)),
            child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(16),
              onTap: _answered ? null : () => _pick(n),
              child: Center(child: Text('$n', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: tc))))));
        }).toList()),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.star, color: Color(0xFFF59E0B), size: 20), const SizedBox(width: 4),
        Text('Skor: $_gameScore', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
      ]),
      const SizedBox(height: 12),
    ]));
  }

  Widget _gameResult() {
    final s = _gameScore>=8?3:_gameScore>=5?2:1;
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Selamat!', style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w800, color: const Color(0xFF3B82F6))),
      const SizedBox(height: 28),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => Icon(Icons.star_rounded, size: 56,
        color: i<s ? const Color(0xFFF59E0B) : Colors.grey.withOpacity(0.3)))),
      const SizedBox(height: 28),
      Container(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)]),
        child: Text('Skor: $_gameScore dari 10', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)))),
      const SizedBox(height: 36),
      _bigBtn('Main Lagi', const Color(0xFF3B82F6), Icons.refresh, _startGame),
      const SizedBox(height: 12),
      _bigBtn('Kembali', Colors.grey[400]!, Icons.home, () => _tabCtrl.animateTo(0)),
    ])));
  }

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
