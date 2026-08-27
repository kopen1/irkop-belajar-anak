import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/kuis_data.dart';
import '../services/audio_service.dart';

class KuisScreen extends StatefulWidget {
  const KuisScreen({super.key});
  @override
  State<KuisScreen> createState() => _KuisScreenState();
}

class _KuisScreenState extends State<KuisScreen> with TickerProviderStateMixin {
  late TabController _tabCtrl;
  static const _cats = ['huruf','angka','warna','hewan'];
  static const _labels = ['Huruf','Angka','Warna','Hewan'];
  static const _icons = [Icons.text_fields, Icons.pin, Icons.palette, Icons.pets];
  static const _colors = [Color(0xFF7C3AED), Color(0xFF3B82F6), Color(0xFFEC4899), Color(0xFF22C55E)];

  List<KuisSoal> _q = [];
  int _cur = 0, _score = 0;
  bool _ans = false; int? _sel; bool _ok = false, _result = false, _confetti = false;
  late AnimationController _bounce, _shake, _conf;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _tabCtrl.addListener(_onTab);
    _loadCat(0);
    _bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _conf = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
  }

  void _onTab() { if (!_tabCtrl.indexIsChanging) _loadCat(_tabCtrl.index); }

  void _loadCat(int i) {
    setState(() { _q = getKuisByKategori(_cats[i]); _cur = 0; _score = 0; _ans = false; _sel = null; _ok = false; _result = false; _confetti = false; });
    _speakQ();
  }

  /// Bicara pertanyaan saat soal muncul — BUKAN saat jawab.
  void _speakQ() {
    if (_q.isEmpty) return;
    AudioService.speak(_q[_cur].pertanyaan);
  }

  void _pick(int i) {
    if (_ans) return;
    final soal = _q[_cur];
    final correct = i == soal.jawabanIndex;
    setState(() { _ans = true; _sel = i; _ok = correct; });

    if (correct) {
      _score++;
      _bounce.forward(from: 0);
      _confetti = true;
      _conf.forward(from: 0).then((_) { if (mounted) setState(() => _confetti = false); });
      AudioService.playSfx('benar');  // SFX: nada naik (web) / "Hore!" (APK)
    } else {
      _shake.forward(from: 0);
      AudioService.playSfx('salah');  // SFX: nada turun (web) / "Coba lagi" (APK)
    }
    // TIDAK ada AudioService.speak(soal.pertanyaan) di sini!

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_cur < _q.length - 1) {
        setState(() { _cur++; _ans = false; _sel = null; _ok = false; });
        _speakQ();  // Bicara soal berikutnya
      } else {
        _finish();
      }
    });
  }

  void _finish() async {
    setState(() => _result = true);
    AudioService.playSfx('yay');
    final cat = _cats[_tabCtrl.index];
    final prefs = await SharedPreferences.getInstance();
    final best = prefs.getInt('kuis_best_$cat') ?? 0;
    if (_score > best) await prefs.setInt('kuis_best_$cat', _score);
  }

  int get _stars => _score >= 8 ? 3 : _score >= 5 ? 2 : 1;

  @override
  void dispose() { _tabCtrl.dispose(); _bounce.dispose(); _shake.dispose(); _conf.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFFF5F3FF), body: Stack(children: [
      SafeArea(child: Column(children: [_appBar(), _tabBarWidget(), const SizedBox(height: 8),
        Expanded(child: _result ? _resultScreen() : _q.isEmpty ? _startScreen() : _quizScreen())])),
      if (_confetti) _confettiOverlay(),
    ]));
  }

  Widget _appBar() => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [
    IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1B4B), size: 28), onPressed: () => Navigator.of(context).pop()),
    Expanded(child: Text('Kuis', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)))),
    IconButton(icon: Icon(AudioService.isMuted ? Icons.volume_off : Icons.volume_up, color: const Color(0xFF1E1B4B), size: 28),
      onPressed: () { AudioService.toggleMute(); setState(() {}); }),
  ]));

  Widget _tabBarWidget() => Container(margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
    child: TabBar(controller: _tabCtrl,
      indicator: BoxDecoration(color: _colors[_tabCtrl.index], borderRadius: BorderRadius.circular(12)),
      indicatorSize: TabBarIndicatorSize.tab, indicatorPadding: const EdgeInsets.all(4), dividerColor: Colors.transparent,
      labelColor: Colors.white, unselectedLabelColor: const Color(0xFF1E1B4B),
      labelStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600),
      tabs: List.generate(4, (i) => Tab(height: 44, child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(_icons[i], size: 18), const SizedBox(width: 6), Text(_labels[i])])))));

  Widget _startScreen() {
    final i = _tabCtrl.index; final c = _colors[i];
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 120, height: 120, decoration: BoxDecoration(color: c.withOpacity(0.15), shape: BoxShape.circle),
        child: Icon(_icons[i], size: 56, color: c)),
      const SizedBox(height: 24),
      Text('Kuis ${_labels[i]}', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B))),
      const SizedBox(height: 8),
      Text('10 soal — pilih jawaban yang benar!', style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
      const SizedBox(height: 40),
      _btn('Mulai Kuis', c, Icons.play_arrow_rounded, () { _loadCat(i); }),
    ])));
  }

  Widget _quizScreen() {
    final s = _q[_cur]; final cc = _colors[_tabCtrl.index];
    final p = (_cur + 1) / _q.length;
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: [
      _progBar(p, cc), const SizedBox(height: 8),
      Text('Soal ${_cur+1} dari ${_q.length}', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
      const Spacer(),
      _display(s, cc), const SizedBox(height: 20),
      Text(s.pertanyaan, style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B)), textAlign: TextAlign.center),
      const Spacer(),
      _opts(s, cc), const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.star, color: Color(0xFFF59E0B), size: 22), const SizedBox(width: 6),
        Text('Skor: $_score', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
      ]),
      const SizedBox(height: 16),
    ]));
  }

  Widget _display(KuisSoal s, Color cc) => AnimatedBuilder(animation: _bounce, builder: (c, ch) => Transform.scale(
    scale: _ok && _ans ? 1+_bounce.value*0.15*(1-_bounce.value)*4 : 1.0, child: ch),
    child: AnimatedBuilder(animation: _shake, builder: (c, ch) => Transform.translate(
      offset: Offset(!_ok && _ans ? sin(_shake.value*6*pi)*8*(1-_shake.value) : 0, 0), child: ch),
      child: _displayContent(s, cc)));

  Widget _displayContent(KuisSoal s, Color cc) {
    switch (s.kategori) {
      case 'huruf': return Container(width: 160, height: 160,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [cc, cc.withOpacity(0.7)]), shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: cc.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))]),
        alignment: Alignment.center,
        child: Text(s.displayText ?? '', style: GoogleFonts.nunito(fontSize: 80, fontWeight: FontWeight.w800, color: Colors.white)));
      case 'angka': final n = int.tryParse(s.displayText ?? '0') ?? 0;
        return Container(width: 160, height: 160,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [cc, cc.withOpacity(0.7)]), shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: cc.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))]),
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(s.displayText ?? '', style: GoogleFonts.nunito(fontSize: 64, fontWeight: FontWeight.w800, color: Colors.white)),
            if (n > 0 && n <= 10) Text('⭐' * n, style: const TextStyle(fontSize: 14)),
          ]));
      case 'warna': final col = Color(s.displayColorHex ?? 0xFF000000);
        return Container(width: 160, height: 160,
          decoration: BoxDecoration(color: col, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: col.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8))]));
      case 'hewan': return Container(width: 160, height: 160,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))]),
        alignment: Alignment.center,
        child: Text(s.displayText ?? '', style: const TextStyle(fontSize: 72)));
      default: return const SizedBox(width: 160, height: 160);
    }
  }

  Widget _opts(KuisSoal s, Color cc) => GridView.count(crossAxisCount: 2, shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.2,
    children: List.generate(s.opsi.length, (i) {
      final sel = _sel == i; final cor = i == s.jawabanIndex;
      Color bg = Colors.white, tc = const Color(0xFF1E1B4B), bc = cc.withOpacity(0.3);
      if (_ans) {
        if (cor) { bg = const Color(0xFF22C55E); tc = Colors.white; bc = const Color(0xFF22C55E); }
        else if (sel) { bg = const Color(0xFFEF4444); tc = Colors.white; bc = const Color(0xFFEF4444); }
        else { bg = Colors.grey.withOpacity(0.1); tc = Colors.grey; bc = Colors.transparent; }
      }
      Widget label;
      if (s.kategori == 'warna') {
        label = Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 24, height: 24, decoration: BoxDecoration(color: getWarnaDariNama(s.opsi[i]), shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2))),
          const SizedBox(width: 8),
          Flexible(child: Text(s.opsi[i], style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: tc), overflow: TextOverflow.ellipsis)),
        ]);
      } else {
        label = Text(s.opsi[i], style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: tc));
      }
      return AnimatedContainer(duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: bc, width: 2),
          boxShadow: [BoxShadow(color: _ans && cor ? const Color(0xFF22C55E).withOpacity(0.3) : Colors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(16),
          onTap: _ans ? null : () => _pick(i), child: Center(child: label))));
    }));

  Widget _progBar(double p, Color c) => Container(height: 10,
    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15), borderRadius: BorderRadius.circular(5)),
    child: AnimatedContainer(duration: const Duration(milliseconds: 400), curve: Curves.easeOut,
      width: MediaQuery.of(context).size.width * 0.92 * p,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [c, c.withOpacity(0.7)]), borderRadius: BorderRadius.circular(5))));

  Widget _resultScreen() {
    final cc = _colors[_tabCtrl.index]; final st = _stars;
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Selamat!', style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w800, color: cc)),
      const SizedBox(height: 8),
      Text('Kuis ${_labels[_tabCtrl.index]} selesai', style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600])),
      const SizedBox(height: 32),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => AnimatedContainer(
        duration: Duration(milliseconds: 400 + i * 200), curve: Curves.elasticOut,
        transform: Matrix4.diagonal3Values(i < st ? 1.0 : 0.6, i < st ? 1.0 : 0.6, 1.0),
        child: Icon(Icons.star_rounded, size: 64, color: i < st ? const Color(0xFFF59E0B) : Colors.grey.withOpacity(0.3))))),
      const SizedBox(height: 32),
      Container(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
        child: Text('Skor: $_score dari ${_q.length}', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)))),
      const SizedBox(height: 40),
      _btn('Ulangi Kuis', cc, Icons.refresh_rounded, () => _loadCat(_tabCtrl.index)),
      const SizedBox(height: 16),
      _btn('Kembali', Colors.grey[400]!, Icons.home_rounded, () => Navigator.of(context).pop()),
    ])));
  }

  Widget _btn(String l, Color c, IconData i, VoidCallback f) => Material(color: Colors.transparent,
    child: InkWell(onTap: f, borderRadius: BorderRadius.circular(20),
      child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: c.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(i, color: Colors.white, size: 26), const SizedBox(width: 10),
          Text(l, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        ]))));

  Widget _confettiOverlay() {
    final rng = Random();
    final ps = List.generate(40, (_) => _P(
      x: rng.nextDouble(), vx: (rng.nextDouble()-0.5)*0.3, vy: -(rng.nextDouble()*0.5+0.2),
      sz: rng.nextDouble()*10+5, c: Color.fromRGBO(rng.nextInt(200)+55, rng.nextInt(200)+55, rng.nextInt(200)+55, 1),
      r: rng.nextDouble()*360, rs: (rng.nextDouble()-0.5)*720));
    return AnimatedBuilder(animation: _conf, builder: (c, _) {
      final t = _conf.value; final w = MediaQuery.of(context).size.width; final h = MediaQuery.of(context).size.height;
      return Stack(children: ps.map((p) {
        final px = (p.x + p.vx*t)*w; final py = (0.3+p.vy*t+0.8*t*t)*h;
        final op = (1-t).clamp(0.0, 1.0); final rot = p.r + p.rs*t;
        return Positioned(left: px, top: py, child: Transform.rotate(angle: rot*pi/180,
          child: Opacity(opacity: op, child: Container(width: p.sz, height: p.sz*0.6,
            decoration: BoxDecoration(color: p.c, borderRadius: BorderRadius.circular(2))))));
      }).toList());
    });
  }
}

class _P { final double x,vx,vy,sz,r,rs; final Color c;
  _P({required this.x,required this.vx,required this.vy,required this.sz,required this.c,required this.r,required this.rs}); }
