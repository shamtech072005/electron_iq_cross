// lib/Widgets/bohr_model_widget.dart

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../Datas/periodic_table_data.dart';

class BohrModelWidget extends StatefulWidget {
  final ChemicalElement element;
  const BohrModelWidget({super.key, required this.element});

  @override
  State<BohrModelWidget> createState() => _BohrModelWidgetState();
}

class _BohrModelWidgetState extends State<BohrModelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // Controls rotation speed
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BohrModelPainter(
        element: widget.element,
        animation: _controller, // Pass the animation controller
      ),
      size: Size.infinite,
    );
  }
}

class BohrModelPainter extends CustomPainter {
  final ChemicalElement element;
  final Animation<double> animation;
  final List<String> shellNames = ['K', 'L', 'M', 'N', 'O', 'P', 'Q'];

  BohrModelPainter({required this.element, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2 * 0.75; // Make it smaller for label space
    final nucleusRadius = maxRadius * 0.18;

    // --- Define Paints ---
    final shellPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final nucleusPaint = Paint()
      ..color = (categoryColors[element.category] ?? Colors.grey).withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final electronPaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.fill;

    final arrowPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1.5;

    // 1. Draw Nucleus and Symbol
    canvas.drawCircle(center, nucleusRadius, nucleusPaint);
    _paintText(canvas, element.symbol, center, fontSize: 20);

    // 2. Draw Shells, Electrons, and Labels
    final shells = element.electronConfiguration;
    final shellSpacing = (maxRadius - nucleusRadius) / (shells.length + 1);

    for (int i = 0; i < shells.length; i++) {
      final shellRadius = nucleusRadius + shellSpacing * (i + 1);
      final electronsInShell = shells[i];

      // Draw shell orbit
      canvas.drawCircle(center, shellRadius, shellPaint);

      // --- Draw Animated Electrons instead of numbers ---
      for (int j = 0; j < electronsInShell; j++) {
        final initialAngle = (2 * pi / electronsInShell) * j;
        // Make outer shells rotate slower
        final angle = initialAngle + (animation.value * 2 * pi) / (i * 0.5 + 1);

        final electronPosition =
            center + Offset(cos(angle) * shellRadius, sin(angle) * shellRadius);
        canvas.drawCircle(electronPosition, 4.0, electronPaint);
      }

      // --- Draw Shell Labels (K, L, M...) with better spacing ---
      if (i < shellNames.length) {
        // Distribute arrows evenly in a 270-degree arc for better spacing
        final angle = (pi * 1.5 / (shells.length - 1)) * i + (pi * 0.75);
        final labelPosition = center + Offset(cos(angle) * (maxRadius + 30), sin(angle) * (maxRadius + 30));
        _paintText(canvas, shellNames[i], labelPosition);

        // Arrow pointing from label towards the shell
        final arrowStart = center + Offset(cos(angle) * (maxRadius + 10), sin(angle) * (maxRadius + 10));
        final arrowEnd = center + Offset(cos(angle) * (shellRadius + 5), sin(angle) * (shellRadius + 5));
        _drawArrow(canvas, arrowPaint, arrowStart, arrowEnd, size: 6);
      }
    }
  }

  void _paintText(Canvas canvas, String text, Offset position, {double fontSize = 14}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }
  
  void _drawArrow(Canvas canvas, Paint paint, Offset start, Offset end, {double size = 8}) {
    canvas.drawLine(start, end, paint);
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    final path = Path();
    path.moveTo(end.dx - size * cos(angle - pi / 6), end.dy - size * sin(angle - pi / 6));
    path.lineTo(end.dx, end.dy);
    path.lineTo(end.dx - size * cos(angle + pi / 6), end.dy - size * sin(angle + pi / 6));
    canvas.drawPath(path, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant BohrModelPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}