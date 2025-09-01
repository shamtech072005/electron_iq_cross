// lib/Widgets/science_background_painter.dart

import 'dart:math';
import 'package:flutter/material.dart';

// 1. Converted to a StatefulWidget to manage the animation
class ScienceBackground extends StatefulWidget {
  const ScienceBackground({super.key});

  @override
  State<ScienceBackground> createState() => _ScienceBackgroundState();
}

class _ScienceBackgroundState extends State<ScienceBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 2. Create a slow, repeating animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // A long duration for slow, subtle movement
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        // 3. Pass the animation down to the painter
        painter: ScienceBackgroundPainter(animation: _controller),
      ),
    );
  }
}

class ScienceBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  // 4. The painter now listens to the animation for repainting
  ScienceBackgroundPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const double spacing = 150.0;

    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        final int patternIndex = ((x + y) / spacing).round() % 3;
        final random = Random(patternIndex + x.toInt() + y.toInt());

        // 5. Use the animation value to create a smooth, drifting offset
        final double time = animation.value * 2 * pi;
        final double animationOffsetX = sin(time + (x * 0.01)) * 25; // x makes paths unique
        final double animationOffsetY = cos(time + (y * 0.01)) * 25; // y makes paths unique

        canvas.save();
        canvas.translate(
          x + (random.nextDouble() * 50) + animationOffsetX,
          y + (random.nextDouble() * 50) + animationOffsetY,
        );
        canvas.rotate(random.nextDouble() * pi);

        switch (patternIndex) {
          case 0:
            _drawHexagon(canvas, paint, 20.0 + random.nextDouble() * 10);
            break;
          case 1:
            _drawMolecule(canvas, paint, 25.0 + random.nextDouble() * 10);
            break;
          case 2:
            _drawAtom(canvas, paint, 20.0 + random.nextDouble() * 10);
            break;
        }
        canvas.restore();
      }
    }
  }
  
  void _drawHexagon(Canvas canvas, Paint paint, double radius) {
    final path = Path();
    for (int i = 0; i <= 6; i++) {
      final double angle = (pi / 3) * i;
      final x = radius * cos(angle);
      final y = radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawMolecule(Canvas canvas, Paint paint, double radius) {
    canvas.drawCircle(Offset.zero, radius * 0.4, paint);
    canvas.drawLine(Offset.zero, Offset(radius, 0), paint);
    canvas.drawCircle(Offset(radius, 0), radius * 0.3, paint);
    canvas.drawLine(Offset.zero, Offset(cos(pi * 2 / 3) * radius, sin(pi * 2 / 3) * radius), paint);
    canvas.drawCircle(Offset(cos(pi * 2 / 3) * radius, sin(pi * 2 / 3) * radius), radius * 0.3, paint);
  }

  void _drawAtom(Canvas canvas, Paint paint, double radius) {
    canvas.drawCircle(Offset.zero, radius * 0.2, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: radius * 2, height: radius * 0.8), paint);
    canvas.save();
    canvas.rotate(pi / 3);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: radius * 2, height: radius * 0.8), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ScienceBackgroundPainter oldDelegate) {
    // The painter should only repaint if the animation object itself changes.
    // The `super(repaint: animation)` handles the frame-by-frame updates.
    return oldDelegate.animation != animation;
  }
}