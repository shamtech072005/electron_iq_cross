// lib/Features/Quiz/Widgets/Flash Card/element_flash_card.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../Datas/periodic_table_data.dart';

// The main widget, now using a Stack and CustomPaint
class ElementFlashCard extends StatelessWidget {
  final ChemicalElement element;
  final bool isGlowing;

  const ElementFlashCard({
    super.key,
    required this.element,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // The CustomPaint widget will draw our hexagon shape and effects
        CustomPaint(
          size: Size.infinite,
          painter: HexagonPainter(
            color: categoryColors[element.category] ?? Colors.grey,
            isGlowing: isGlowing,
          ),
        ),
        // The text content is placed on top of the painted hexagon
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                element.atomicNumber.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              Text(
                element.symbol,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Text(
                element.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withAlpha(230),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

// CustomPainter to draw a perfect regular hexagon with effects
class HexagonPainter extends CustomPainter {
  final Color color;
  final bool isGlowing;

  HexagonPainter({required this.color, required this.isGlowing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Create the hexagonal path
    final path = _createHexagonPath(size, center, radius);
    
    // --- Draw the Glow Effect ---
    if (isGlowing) {
      final glowPaint = Paint()
        ..color = Colors.tealAccent.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
      canvas.drawPath(path, glowPaint);
    }
    
    // --- Draw the Inner Hexagon Background ---
    final fillPaint = Paint()..color = color.withAlpha(50);
    canvas.drawPath(path, fillPaint);
    
    // --- Draw the Inner Detail Shape ---
    final innerPath = _createHexagonPath(size, center, radius * 0.9);
    final innerPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(innerPath, innerPaint);
    
    // --- Draw the Main Border ---
    final borderPaint = Paint()
      ..color = isGlowing ? Colors.tealAccent : color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, borderPaint);
  }

  Path _createHexagonPath(Size size, Offset center, double radius) {
    final path = Path();
    for (int i = 0; i <= 6; i++) {
      final double angle = (pi / 3) * i - (pi / 2); // Rotated to be point-up
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}