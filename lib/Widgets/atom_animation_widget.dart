// lib/Widgets/atom_animation_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../Datas/periodic_table_data.dart';

class AtomAnimationWidget extends StatefulWidget {
  final ChemicalElement element;

  const AtomAnimationWidget({super.key, required this.element});

  @override
  State<AtomAnimationWidget> createState() => _AtomAnimationWidgetState();
}

class _AtomAnimationWidgetState extends State<AtomAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
      // Use a LayoutBuilder to get the available space
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate a font size relative to the widget's width

          return CustomPaint(
            painter: AtomPainter(
              animation: _controller,
              element: widget.element,
            ),
            child: Center(
              child: Text(
                widget.element.symbol,
                style: TextStyle(
                  // Apply the responsive font size
                  // .clamp sets a min and max size to prevent it from getting too small or too large
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AtomPainter extends CustomPainter {
  final Animation<double> animation;
  final ChemicalElement element;

  AtomPainter({required this.animation, required this.element})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2 * 0.9;

    final nucleusRadius = maxRadius * 0.15;

    // Paint for shells and nucleus
    final shellPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final nucleusPaint = Paint()
      ..color = categoryColors[element.category] ?? Colors.grey
      ..style = PaintingStyle.fill;

    final electronPaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.fill;

    // Draw Nucleus
    canvas.drawCircle(center, nucleusRadius, nucleusPaint);

    // Draw Shells and Electrons
    final shells = element.electronConfiguration;
    final shellSpacing = (maxRadius - nucleusRadius) / (shells.length + 1);

    for (int i = 0; i < shells.length; i++) {
      final shellRadius = nucleusRadius + shellSpacing * (i + 1.5);

      // Draw shell orbit
      canvas.drawCircle(center, shellRadius, shellPaint);

      // Draw electrons
      int electronsInShell = shells[i];
      for (int j = 0; j < electronsInShell; j++) {
        // Distribute electrons evenly
        final initialAngle = (2 * pi / electronsInShell) * j;

        // Animate the rotation, making outer shells slower
        final angle = initialAngle + (animation.value * 2 * pi) / (i + 1);

        // Calculate electron position
        final electronX = center.dx + shellRadius * cos(angle);
        final electronY = center.dy + shellRadius * sin(angle);

        canvas.drawCircle(Offset(electronX, electronY), 4.0, electronPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
