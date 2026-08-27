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

class _KuisScreenState extends State<KuisScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  static const _categories = ['huruf', 'angka', 'warna', 'hewan'];
  static const _categoryLabels = ['Huruf', 'Angka', 'Warna', 'Hewan'];
  static const _categoryIcons = [Icons.text_fields, Icons.pin, Icons.palette, Icons.pets];
  static const _categoryColors = [
    Color(0xFF7C3AED),
    Color(0xFF3B82F6),
    Color(0xFFEC4899),
    Color(0xFF22C55E),
  ];

  List<KuisSoal> _questions = [];
  int _currentQ = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedIdx;
  bool _isCorrect = false;
  bool _showResult = false;
  bool _showConfetti = false;

  late AnimationController _bounceCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadCategory(0);

    _bounceCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    );
    _shakeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    );
    _confettiCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800),
    );
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _loadCategory(_tabController.index);
    }
  }

  void _loadCategory(int idx) {
    setState(() {
      _questions = getKuisByKategori(_categories[idx]);
      _currentQ = 0;
      _score = 0;
      _answered = false;
      _selectedIdx = null;
      _isCorrect = false;
      _showResult = false;
      _showConfetti = false;
    });
  }

  void _selectAnswer(int idx) {
    if (_answered) return;
    final soal = _questions[_currentQ];
    final correct = idx == soal.jawabanIndex;

    setState(() {
      _answered = true;
      _selectedIdx = idx;
      _isCorrect = correct;
    });

    if (correct) {
      _score++;
      _bounceCtrl.forward(from: 0);
      _showConfetti = true;
      _confettiCtrl.forward(from: 0).then((_) {
        if (mounted) setState(() => _showConfetti = false);
      });
      AudioService.playSfx('benar');
    } else {
      _shakeCtrl.forward(from: 0);
      AudioService.playSfx('salah');
    }

    AudioService.speak(soal.pertanyaan);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_currentQ < _questions.length - 1) {
        setState(() {
          _currentQ++;
          _answered = false;
          _selectedIdx = null;
          _isCorrect = false;
        });
        AudioService.speak(_questions[_currentQ].pertanyaan);
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() async {
    setState(() => _showResult = true);
    AudioService.playSfx('yay');

    final cat = _categories[_tabController.index];
    final prefs = await SharedPreferences.getInstance();
    final key = 'kuis_best_$cat';
    final best = prefs.getInt(key) ?? 0;
    if (_score > best) await prefs.setInt(key, _score);
  }

  int get _starCount {
    if (_score >= 8) return 3;
    if (_score >= 5) return 2;
    return 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bounceCtrl.dispose();
    _shakeCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                _buildTabBar(),
                const SizedBox(height: 8),
                Expanded(
                  child: _showResult
                      ? _buildResultScreen()
                      : _questions.isEmpty
                          ? _buildStartScreen()
                          : _buildQuizScreen(),
                ),
              ],
            ),
          ),
          if (_showConfetti) _buildConfettiOverlay(),
        ],
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
          Expanded(
            child: Text(
              'Kuis',
              style: GoogleFonts.nunito(
                fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              AudioService.isMuted ? Icons.volume_off : Icons.volume_up,
              color: const Color(0xFF1E1B4B), size: 28,
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: _categoryColors[_tabController.index],
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF1E1B4B),
        labelStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600),
        tabs: List.generate(4, (i) {
          return Tab(
            height: 44,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_categoryIcons[i], size: 18),
                const SizedBox(width: 6),
                Text(_categoryLabels[i]),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStartScreen() {
    final catIdx = _tabController.index;
    final color = _categoryColors[catIdx];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_categoryIcons[catIdx], size: 56, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              'Kuis ${_categoryLabels[catIdx]}',
              style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)),
            ),
            const SizedBox(height: 8),
            Text(
              '10 soal — pilih jawaban yang benar!',
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildBigButton(
              label: 'Mulai Kuis',
              color: color,
              icon: Icons.play_arrow_rounded,
              onTap: () {
                _loadCategory(catIdx);
                AudioService.speak(_questions[_currentQ].pertanyaan);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizScreen() {
    final soal = _questions[_currentQ];
    final catColor = _categoryColors[_tabController.index];
    final progress = (_currentQ + 1) / _questions.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildProgressBar(progress, catColor),
          const SizedBox(height: 8),
          Text(
            'Soal ${_currentQ + 1} dari ${_questions.length}',
            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          const Spacer(flex: 1),
          _buildDisplay(soal, catColor),
          const SizedBox(height: 20),
          Text(
            soal.pertanyaan,
            style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B)),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 1),
          _buildOptions(soal, catColor),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Color(0xFFF59E0B), size: 22),
              const SizedBox(width: 6),
              Text(
                'Skor: $_score',
                style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B)),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDisplay(KuisSoal soal, Color catColor) {
    return AnimatedBuilder(
      animation: _bounceCtrl,
      builder: (context, child) {
        final scale = 1.0 + (_bounceCtrl.value * 0.15 * (1 - _bounceCtrl.value) * 4);
        return Transform.scale(
          scale: _isCorrect && _answered ? scale : 1.0,
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _shakeCtrl,
        builder: (context, child) {
          final offset = sin(_shakeCtrl.value * 6 * pi) * 8 * (1 - _shakeCtrl.value);
          return Transform.translate(
            offset: Offset(!_isCorrect && _answered ? offset : 0, 0),
            child: child,
          );
        },
        child: _buildDisplayContent(soal, catColor),
      ),
    );
  }

  Widget _buildDisplayContent(KuisSoal soal, Color catColor) {
    switch (soal.kategori) {
      case 'huruf':
        return Container(
          width: 160, height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [catColor, catColor.withOpacity(0.7)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: catColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            soal.displayText ?? '',
            style: GoogleFonts.nunito(fontSize: 80, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        );

      case 'angka':
        final n = int.tryParse(soal.displayText ?? '0') ?? 0;
        return Container(
          width: 160, height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [catColor, catColor.withOpacity(0.7)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: catColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                soal.displayText ?? '',
                style: GoogleFonts.nunito(fontSize: 64, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              if (n > 0 && n <= 10)
                Text('⭐' * n, style: const TextStyle(fontSize: 14)),
            ],
          ),
        );

      case 'warna':
        final color = Color(soal.displayColorHex ?? 0xFF000000);
        return Container(
          width: 160, height: 160,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8)),
            ],
          ),
        );

      case 'hewan':
        return Container(
          width: 160, height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(soal.displayText ?? '', style: const TextStyle(fontSize: 72)),
        );

      default:
        return const SizedBox(width: 160, height: 160);
    }
  }

  Widget _buildOptions(KuisSoal soal, Color catColor) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: List.generate(soal.opsi.length, (i) {
        final isSelected = _selectedIdx == i;
        final isCorrectOpt = i == soal.jawabanIndex;
        Color bgColor = Colors.white;
        Color textColor = const Color(0xFF1E1B4B);
        Color borderColor = catColor.withOpacity(0.3);

        if (_answered) {
          if (isCorrectOpt) {
            bgColor = const Color(0xFF22C55E);
            textColor = Colors.white;
            borderColor = const Color(0xFF22C55E);
          } else if (isSelected && !isCorrectOpt) {
            bgColor = const Color(0xFFEF4444);
            textColor = Colors.white;
            borderColor = const Color(0xFFEF4444);
          } else {
            bgColor = Colors.grey.withOpacity(0.1);
            textColor = Colors.grey;
            borderColor = Colors.transparent;
          }
        }

        Widget label;
        if (soal.kategori == 'warna') {
          label = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: getWarnaDariNama(soal.opsi[i]),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  soal.opsi[i],
                  style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        } else {
          label = Text(
            soal.opsi[i],
            style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: textColor),
          );
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: (_answered && isCorrectOpt)
                    ? const Color(0xFF22C55E).withOpacity(0.3)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _answered ? null : () => _selectAnswer(i),
              child: Center(child: label),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProgressBar(double progress, Color color) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        width: MediaQuery.of(context).size.width * 0.92 * progress,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final catColor = _categoryColors[_tabController.index];
    final stars = _starCount;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selamat!',
              style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w800, color: catColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Kuis ${_categoryLabels[_tabController.index]} selesai',
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 400 + i * 200),
                  curve: Curves.elasticOut,
                  transform: Matrix4.diagonal3Values(
                    i < stars ? 1.0 : 0.6,
                    i < stars ? 1.0 : 0.6,
                    1.0,
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    size: 64,
                    color: i < stars ? const Color(0xFFF59E0B) : Colors.grey.withOpacity(0.3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Text(
                'Skor: $_score dari ${_questions.length}',
                style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)),
              ),
            ),
            const SizedBox(height: 40),
            _buildBigButton(
              label: 'Ulangi Kuis',
              color: catColor,
              icon: Icons.refresh_rounded,
              onTap: () => _loadCategory(_tabController.index),
            ),
            const SizedBox(height: 16),
            _buildBigButton(
              label: 'Kembali',
              color: Colors.grey[400]!,
              icon: Icons.home_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiOverlay() {
    final rng = Random();
    final particles = List.generate(40, (_) {
      return _ConfettiParticle(
        x: rng.nextDouble(),
        vx: (rng.nextDouble() - 0.5) * 0.3,
        vy: -(rng.nextDouble() * 0.5 + 0.2),
        size: rng.nextDouble() * 10 + 5,
        color: Color.fromRGBO(
          rng.nextInt(200) + 55,
          rng.nextInt(200) + 55,
          rng.nextInt(200) + 55,
          1,
        ),
        rotation: rng.nextDouble() * 360,
        rotSpeed: (rng.nextDouble() - 0.5) * 720,
      );
    });

    return AnimatedBuilder(
      animation: _confettiCtrl,
      builder: (context, _) {
        final t = _confettiCtrl.value;
        final w = MediaQuery.of(context).size.width;
        final h = MediaQuery.of(context).size.height;

        return Stack(
          children: particles.map((p) {
            final px = (p.x + p.vx * t) * w;
            final py = (0.3 + p.vy * t + 0.8 * t * t) * h;
            final opacity = (1 - t).clamp(0.0, 1.0);
            final rot = p.rotation + p.rotSpeed * t;

            return Positioned(
              left: px,
              top: py,
              child: Transform.rotate(
                angle: rot * pi / 180,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: p.size,
                    height: p.size * 0.6,
                    decoration: BoxDecoration(
                      color: p.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ConfettiParticle {
  final double x, vx, vy, size, rotation, rotSpeed;
  final Color color;
  _ConfettiParticle({
    required this.x, required this.vx, required this.vy,
    required this.size, required this.color,
    required this.rotation, required this.rotSpeed,
  });
}
