// lib/Widgets/valence_atom_animation_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../Datas/periodic_table_data.dart';

class ValenceAtomAnimationWidget extends StatefulWidget {
  final ChemicalElement element;

  const ValenceAtomAnimationWidget({super.key, required this.element});

  @override
  State<ValenceAtomAnimationWidget> createState() => _ValenceAtomAnimationWidgetState();
}

class _ValenceAtomAnimationWidgetState extends State<ValenceAtomAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Slightly faster rotation
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter: ValenceAtomPainter(
          animation: _controller,
          element: widget.element,
        ),
      ),
    );
  }
}

class ValenceAtomPainter extends CustomPainter {
  final Animation<double> animation;
  final ChemicalElement element;

  ValenceAtomPainter({required this.animation, required this.element})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;
    final nucleusRadius = radius * 0.4;

    final shellPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final nucleusPaint = Paint()
      ..color = categoryColors[element.category] ?? Colors.grey
      ..style = PaintingStyle.fill;

    final electronPaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.fill;

    // Draw Nucleus and Symbol
    canvas.drawCircle(center, nucleusRadius, nucleusPaint);
    final textPainter = TextPainter(
      text: TextSpan(
          text: element.symbol,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));

    // Draw the Valence Shell
    canvas.drawCircle(center, radius, shellPaint);

    // Draw and Animate Valence Electrons
    final int valenceElectrons = element.electronConfiguration.last;

    for (int i = 0; i < valenceElectrons; i++) {
      final initialAngle = (2 * pi / valenceElectrons) * i;
      final angle = initialAngle + (animation.value * 2 * pi);
      final electronPosition =
          center + Offset(cos(angle) * radius, sin(angle) * radius);
      canvas.drawCircle(electronPosition, 4.0, electronPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}