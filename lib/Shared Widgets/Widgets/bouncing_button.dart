// lib/Shared Widgets/Widgets/bouncing_button.dart

import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const BouncingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeIn),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle effectiveStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
    ).merge(widget.style);

    return Listener(
      onPointerDown: (_) {
        if (widget.onPressed != null) {
          _scaleController.forward();
        }
      },
      onPointerUp: (_) {
        if (widget.onPressed != null) {
          _scaleController.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: _SlideGradientTransform(percent: _shimmerController.value),
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.2), // The peak highlight is subtle
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                ).createShader(bounds);
              },
              // --- THIS IS THE FIX ---
              // Changed from srcIn to overlay to ensure text is always visible.
              blendMode: BlendMode.overlay,
              child: child,
            );
          },
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: effectiveStyle,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  final double percent;

  const _SlideGradientTransform({required this.percent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final double a = percent * 2 - 1;
    return Matrix4.identity()..translate(bounds.width * a, bounds.height * a);
  }
}