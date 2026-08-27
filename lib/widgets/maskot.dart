import 'package:flutter/material.dart';

/// Maskot Irkop Kids — animasi pulse lembut (PRD B.2.7)
class Maskot extends StatefulWidget {
  final double size;
  final String emoji;
  const Maskot({super.key, this.size = 96, this.emoji = '⭐'});

  @override
  State<Maskot> createState() => _MaskotState();
}

class _MaskotState extends State<Maskot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);
  late final Animation<double> _s = Tween(begin: 0.92, end: 1.08)
      .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _s, child: Text(widget.emoji, style: TextStyle(fontSize: widget.size)));
  }
}
