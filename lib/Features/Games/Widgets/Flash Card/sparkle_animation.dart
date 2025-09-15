// lib/Features/Quiz/Widgets/Flash Card/sparkle_animation.dart

import 'dart:math';
import 'package:flutter/material.dart';

class SparkleAnimation extends StatefulWidget {
  const SparkleAnimation({super.key});

  @override
  State<SparkleAnimation> createState() => _SparkleAnimationState();
}

class _SparkleAnimationState extends State<SparkleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      // Create new particles
      if (_particles.length < 50) {
        _particles.add(Particle(random: _random));
      }
      // Update existing particles
      for (var particle in _particles) {
        particle.update();
      }
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SparklePainter(particles: _particles, animation: _controller),
      child: const SizedBox.expand(),
    );
  }
}

class SparklePainter extends CustomPainter {
  final List<Particle> particles;
  final Animation<double> animation;

  SparklePainter({required this.particles, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center + particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SparklePainter oldDelegate) => true;
}

// A simple particle model
class Particle {
  Offset position;
  Color color;
  double size;
  double opacity;
  final double speed;
  final double angle;
  final Random random;

  Particle({required this.random})
      : position = Offset.zero,
        color = Colors.tealAccent.withOpacity(random.nextDouble()),
        size = random.nextDouble() * 3 + 1,
        opacity = 1.0,
        speed = random.nextDouble() * 2 + 1,
        angle = random.nextDouble() * 2 * pi;

  void update() {
    position += Offset(cos(angle) * speed, sin(angle) * speed);
    opacity -= 0.01;
    if (opacity <= 0) {
      // Reset particle
      opacity = 1.0;
      position = Offset.zero;
    }
  }
}

