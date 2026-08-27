import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_service.dart';

class HurufScreen extends StatefulWidget {
  const HurufScreen({super.key});
  @override
  State<HurufScreen> createState() => _HurufScreenState();
}

class _HurufScreenState extends State<HurufScreen> {
  static const _data = [
    ('A','a','Apel','🍎'), ('B','b','Bola','⚽'), ('C','c','Ceri','🍒'),
    ('D','d','Domba','🐑'), ('E','e','Elang','🦅'), ('F','f','Flamingo','🦩'),
    ('G','g','Gajah','🐘'), ('H','h','Harimau','🐅'), ('I','i','Ikan','🐟'),
    ('J','j','Jeruk','🍊'), ('K','k','Kucing','🐱'), ('L','l','Lebah','🐝'),
    ('M','m','Monyet','🐵'), ('N','n','Naga','🐉'), ('O','o','Onta','🐫'),
    ('P','p','Panda','🐼'), ('Q','q','Quran','📖'), ('R','r','Rubah','🦊'),
    ('S','s','Singa','🦁'), ('T','t','Tikus','🐭'), ('U','u','Ular','🐍'),
    ('V','v','Vanili','🍦'), ('W','w','Wortel','🥕'), ('X','x','Xilofon','🎵'),
    ('Y','y','Yak','🐃'), ('Z','z','Zebra','🦓'),
  ];

  static const _rowColors = [
    [Color(0xFF7C3AED), Color(0xFF8B5CF6), Color(0xFFA78BFA), Color(0xFF7C3AED), Color(0xFF8B5CF6), Color(0xFFA78BFA), Color(0xFF7C3AED)],
    [Color(0xFF3B82F6), Color(0xFF60A5FA), Color(0xFF93C5FD), Color(0xFF3B82F6), Color(0xFF60A5FA), Color(0xFF93C5FD), Color(0xFF3B82F6)],
    [Color(0xFF22C55E), Color(0xFF4ADE80), Color(0xFF86EFAC), Color(0xFF22C55E), Color(0xFF4ADE80), Color(0xFF86EFAC), Color(0xFF22C55E)],
    [Color(0xFFF97316), Color(0xFFFB923C), Color(0xFFFDBA74), Color(0xFFF97316), Color(0xFFFB923C), Color(0xFF86EFAC), Color(0xFFF97316)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1B4B), size: 28),
                    onPressed: () => Navigator.of(context).pop()),
                  Expanded(child: Text('Huruf', style: GoogleFonts.nunito(
                    fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1E1B4B)))),
                  IconButton(icon: Icon(AudioService.isMuted ? Icons.volume_off : Icons.volume_up,
                    color: const Color(0xFF1E1B4B), size: 28),
                    onPressed: () { AudioService.toggleMute(); setState(() {}); }),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.85),
                itemCount: 26,
                itemBuilder: (context, idx) {
                  final row = idx ~/ 7;
                  final col = idx % 7;
                  final (besar, kecil, contoh, emoji) = _data[idx];
                  final color = _rowColors[row][col];
                  return GestureDetector(
                    onTap: () => _showPopup(besar, kecil, contoh, emoji, color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [color, color.withOpacity(0.75)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(besar, style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text(kecil, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text('Tap huruf untuk mendengar', style: GoogleFonts.nunito(fontSize: 13, color: Colors.grey[500])),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showPopup(String besar, String kecil, String contoh, String emoji, Color color) {
    AudioService.speak('$besar, $contoh');
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 12))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 130, height: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(besar, style: GoogleFonts.nunito(fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white)),
                      Text(kecil, style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.85))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 4),
                Text('$besar - $contoh', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF1E1B4B))),
                const SizedBox(height: 24),
                Material(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text('Tutup', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
