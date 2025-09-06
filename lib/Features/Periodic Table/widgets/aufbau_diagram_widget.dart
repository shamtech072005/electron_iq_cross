// lib/Widgets/aufbau_diagram_widget.dart

import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../Datas/periodic_table_data.dart';

// Helper class to hold detailed subshell data including electron count
class SubshellInfo {
  final String name;
  final int electronCount;
  SubshellInfo(this.name, this.electronCount);
}

class AufbauDiagramWidget extends StatefulWidget {
  final ChemicalElement element;
  const AufbauDiagramWidget({super.key, required this.element});

  @override
  State<AufbauDiagramWidget> createState() => _AufbauDiagramWidgetState();
}

class _AufbauDiagramWidgetState extends State<AufbauDiagramWidget>
    with TickerProviderStateMixin {
  late AnimationController _fillingController;
  late Animation<int> _fillingAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  List<SubshellInfo> _subshellData = [];
  String? _halfFilledOrbitalName;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _calculateSubshellData();

    _fillingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _subshellData.length),
    );
    _fillingAnimation =
        StepTween(begin: 0, end: _subshellData.length).animate(_fillingController);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    if (_halfFilledOrbitalName != null) {
      _bounceController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _fillingController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _calculateSubshellData() {
    int electrons = widget.element.atomicNumber;
    const orbitals = ['1s','2s','2p','3s','3p','4s','3d','4p','5s','4d','5p','6s','4f','5d','6p','7s','5f','6d','7p','8s'];
    final maxElectrons = {'s': 2, 'p': 6, 'd': 10, 'f': 14};
    
    List<SubshellInfo> data = [];
    for (String orbital in orbitals) {
      if (electrons <= 0) break;
      String type = orbital.substring(1);
      int maxInOrbital = maxElectrons[type]!;
      int electronsInThisOrbital = min(electrons, maxInOrbital);
      
      data.add(SubshellInfo(orbital, electronsInThisOrbital));
      
      if (electronsInThisOrbital < maxInOrbital) {
        _halfFilledOrbitalName = orbital;
      }
      electrons -= maxInOrbital;
    }
    _subshellData = data;
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = true;
      _bounceController.stop();
    });
    _fillingController.reset();
    _fillingController.forward().whenComplete(() {
      setState(() {
        _isAnimating = false;
        if (_halfFilledOrbitalName != null) {
          _bounceController.repeat(reverse: true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge([_fillingAnimation, _bounceAnimation]),
            builder: (context, child) {
              List<SubshellInfo> visibleSubshells;
              if (_isAnimating) {
                visibleSubshells = _subshellData.sublist(0, _fillingAnimation.value);
              } else {
                visibleSubshells = _subshellData;
              }

              return CustomPaint(
                painter: AufbauDiagramPainter(
                  subshellData: visibleSubshells,
                  bounceAnimationValue: _bounceAnimation.value,
                  halfFilledOrbitalName: _halfFilledOrbitalName,
                  isAnimating: _isAnimating,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text("Start Animation"),
          onPressed: _startAnimation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class AufbauDiagramPainter extends CustomPainter {
  final List<SubshellInfo> subshellData;
  final double bounceAnimationValue;
  final String? halfFilledOrbitalName;
  final bool isAnimating;

  AufbauDiagramPainter({
    required this.subshellData,
    required this.bounceAnimationValue,
    required this.halfFilledOrbitalName,
    required this.isAnimating,
  });

  final orbitalLayout = const [
    ['1s'], ['2s', '2p'], ['3s', '3p', '3d'], ['4s', '4p', '4d', '4f'],
    ['5s', '5p', '5d', '5f'], ['6s', '6p', '6d', '6f'], ['7s', '7p', '7d', '7f'], ['8s'],
  ];

  final orbitalColors = {
    's': const Color(0xFFE57373), 'p': const Color(0xFF81C784),
    'd': const Color(0xFF64B5F6), 'f': const Color(0xFF9575CD),
  };
  
  final linePaint = Paint()..color = Colors.white24..strokeWidth = 1.5..style = PaintingStyle.stroke;

  String _getSuperscript(int number) {
    const superscripts = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];
    if (number > 9) return '¹${superscripts[number % 10]}';
    return superscripts[number];
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Sizing and centering logic
    final double scaleFactor = 0.9;
    final double effectiveHeight = size.height * scaleFactor;
    final double rowHeight = effectiveHeight / orbitalLayout.length;
    final double circleRadius = rowHeight * 0.45;
    final double horizontalSpacing = circleRadius * 2.4;
    double maxContentWidth = 0;
    for(var row in orbitalLayout) {
        final width = (row.length * (circleRadius * 2)) + (max(0, row.length - 1) * (horizontalSpacing - circleRadius * 2));
        if (width > maxContentWidth) maxContentWidth = width;
    }
    final double xOffset = (size.width - maxContentWidth) / 2;
    final double yOffset = (size.height - effectiveHeight) / 2;
    final textStyle = TextStyle(color: Colors.white, fontSize: circleRadius * 0.7, fontWeight: FontWeight.bold);

    Map<String, Offset> orbitalCenters = {};
    for (int i = 0; i < orbitalLayout.length; i++) {
      final row = orbitalLayout[i];
      final double y = yOffset + (i * rowHeight) + (rowHeight / 2);
      for (int j = 0; j < row.length; j++) {
        final x = xOffset + (j * horizontalSpacing);
        orbitalCenters[row[j]] = Offset(x, y);
      }
    }

    // Draw lines behind
    const fillingOrder = ['1s','2s','2p','3s','3p','4s','3d','4p','5s','4d','5p','6s','4f','5d','6p','7s','5f','6d','7p','8s'];
    for (int i = 0; i < fillingOrder.length - 1; i++) {
        final start = orbitalCenters[fillingOrder[i]];
        final end = orbitalCenters[fillingOrder[i+1]];
        if (start != null && end != null) {
            canvas.drawLine(start, end, linePaint);
        }
    }

    final Map<String, SubshellInfo> subshellMap = { for (var v in subshellData) v.name : v };

    // Draw circles and text
    orbitalCenters.forEach((name, center) {
      final bool isFilled = subshellMap.containsKey(name);
      final orbitalType = name.substring(1);
      final color = orbitalColors[orbitalType] ?? Colors.grey;
      
      double currentRadius = circleRadius;
      if (!isAnimating && name == halfFilledOrbitalName) {
        currentRadius *= bounceAnimationValue;
      }

      canvas.drawCircle(center, currentRadius, Paint()..color = isFilled ? color : Colors.grey[800]!);
      canvas.drawCircle(center, currentRadius, Paint()..color = Colors.black38..style = PaintingStyle.stroke..strokeWidth = 1.5);
      
      String textToShow = name;
      if(isFilled) {
        textToShow += _getSuperscript(subshellMap[name]!.electronCount);
      }

      _paintText(canvas, textToShow, center, textStyle.copyWith(color: isFilled ? Colors.white : Colors.grey[600]));
    });

    if (!isAnimating && halfFilledOrbitalName != null) {
      final Offset? targetCenter = orbitalCenters[halfFilledOrbitalName!];
      if (targetCenter != null) {
        final unfilledTextStyle = TextStyle(color: Colors.yellowAccent.withOpacity(0.9), fontSize: circleRadius * 0.6, fontWeight: FontWeight.bold);
        final textPosition = targetCenter + Offset(0, circleRadius + 8);
        _paintText(canvas, '(unfilled)', textPosition, unfilledTextStyle);
      }
    }
  }

  void _paintText(Canvas canvas, String text, Offset position, TextStyle style) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: style), textDirection: ui.TextDirection.ltr,)..layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }
  
  @override
  bool shouldRepaint(covariant AufbauDiagramPainter oldDelegate) {
    return true; // Simplest way to ensure animation updates
  }
}