import 'package:flutter/material.dart';

/// Kartu materi dengan animasi bounce saat di-tap
/// PRD C.4 — scale bounce (1.0 -> 1.15 -> 1.0), 200ms
class MateriCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const MateriCard({super.key, required this.child, required this.onTap});

  @override
  State<MateriCard> createState() => _MateriCardState();
}

class _MateriCardState extends State<MateriCard> {
  bool _bump = false;

  void _tap() {
    setState(() => _bump = true);
    widget.onTap();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _bump = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tap,
      child: AnimatedScale(
        scale: _bump ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}
