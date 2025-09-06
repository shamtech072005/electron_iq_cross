// lib/Widgets/subshell_config_widget.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../Datas/periodic_table_data.dart';

// Helper class to hold parsed subshell data
class Subshell {
  final String name;
  final int electrons;
  final int principalShell; // 1 for K, 2 for L, etc.

  Subshell(this.name, this.electrons, this.principalShell);
}

class SubshellConfigWidget extends StatefulWidget {
  final ChemicalElement element;

  const SubshellConfigWidget({super.key, required this.element});

  @override
  State<SubshellConfigWidget> createState() => _SubshellConfigWidgetState();
}

class _SubshellConfigWidgetState extends State<SubshellConfigWidget> {
  List<Subshell> _subshells = [];
  int _selectedPrincipalShell = 1; // K shell is 1
  Timer? _autoNavTimer;
  bool _isAutoNavigating = true;

  final List<String> _principalShellNames = ['K', 'L', 'M', 'N', 'O', 'P', 'Q'];

  @override
  void initState() {
    super.initState();
    _parseConfiguration();
    _startAutoNavigation();
  }

  @override
  void dispose() {
    _autoNavTimer?.cancel(); // Important: cancel timer to prevent memory leaks
    super.dispose();
  }

  void _startAutoNavigation() {
    // Ensure we don't have multiple timers running
    _autoNavTimer?.cancel();
    _autoNavTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isAutoNavigating) {
        timer.cancel(); // Stop if auto-navigation is disabled
        return;
      }
      // mounted check is a good practice for async operations in State
      if (mounted) {
        setState(() {
          // Cycle through the available principal shells
          _selectedPrincipalShell = (_selectedPrincipalShell % widget.element.period) + 1;
        });
      }
    });
  }

  void _stopAutoNavigation() {
    if (_isAutoNavigating) {
      _isAutoNavigating = false;
      _autoNavTimer?.cancel();
    }
  }
  
  void _parseConfiguration() {
    int electrons = widget.element.atomicNumber;
    const orbitals = ['1s','2s','2p','3s','3p','4s','3d','4p','5s','4d','5p','6s','4f','5d','6p','7s','5f','6d','7p'];
    final maxElectrons = {'s': 2, 'p': 6, 'd': 10, 'f': 14};
    
    List<Subshell> parsedSubshells = [];
    for (String orbital in orbitals) {
      if (electrons <= 0) break;
      String type = orbital.substring(1);
      int principal = int.parse(orbital.substring(0, 1));
      int maxInOrbital = maxElectrons[type]!;
      int electronsInOrbital = electrons > maxInOrbital ? maxInOrbital : electrons;
      
      parsedSubshells.add(Subshell('$orbital', electronsInOrbital, principal));
      electrons -= electronsInOrbital;
    }
    // No need for setState here as it's called during initState
    _subshells = parsedSubshells;
  }

  @override
  Widget build(BuildContext context) {
    final currentSubshells = _subshells
        .where((s) => s.principalShell == _selectedPrincipalShell)
        .toList();

    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: currentSubshells.map((subshell) {
              return Expanded(
                child: SubshellAtomView(
                  key: ValueKey(subshell.name),
                  subshell: subshell,
                  element: widget.element,
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1, color: Colors.white12),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: List.generate(widget.element.period, (index) {
            int shellNumber = index + 1;
            bool isSelected = shellNumber == _selectedPrincipalShell;
            return ActionChip(
              label: Text(_principalShellNames[index]),
              backgroundColor:
                  isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
              labelStyle: const TextStyle(color: Colors.white),
              onPressed: () {
                // On user interaction, stop the auto-navigation
                _stopAutoNavigation();
                setState(() {
                  _selectedPrincipalShell = shellNumber;
                });
              },
            );
          }),
        ),
      ],
    );
  }
}


// --- WIDGET TO DRAW THE ATOM VISUALIZATION ---
class SubshellAtomView extends StatefulWidget {
  final Subshell subshell;
  final ChemicalElement element;

  const SubshellAtomView(
      {super.key, required this.subshell, required this.element});

  @override
  State<SubshellAtomView> createState() => _SubshellAtomViewState();
}

class _SubshellAtomViewState extends State<SubshellAtomView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomPaint(
            painter: SubshellAtomPainter(
              subshell: widget.subshell,
              element: widget.element,
              animation: _controller,
            ),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.subshell.name}${_getSuperscript(widget.subshell.electrons)}',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              fontSize: 16),
        )
      ],
    );
  }

  String _getSuperscript(int number) {
    const superscripts = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];
    if (number > 9) {
      return '¹${superscripts[number % 10]}';
    }
    return superscripts[number];
  }
}

// --- CUSTOM PAINTER FOR THE VISUALIZATION ---
class SubshellAtomPainter extends CustomPainter {
  final Subshell subshell;
  final ChemicalElement element;
  final Animation<double> animation;

  SubshellAtomPainter(
      {required this.subshell, required this.element, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.7;
    final nucleusRadius = radius * 0.3;

    final nucleusPaint = Paint()
      ..color = categoryColors[element.category] ?? Colors.grey;
    final shellPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final electronPaint = Paint()..color = Colors.yellowAccent;

    canvas.drawCircle(center, nucleusRadius, nucleusPaint);

    canvas.drawCircle(center, radius, shellPaint);
    for (int i = 0; i < subshell.electrons; i++) {
      final angle = (2 * pi / subshell.electrons) * i + (animation.value * 2 * pi);
      final electronPosition =
          center + Offset(cos(angle) * radius, sin(angle) * radius);
      canvas.drawCircle(electronPosition, 4.0, electronPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SubshellAtomPainter oldDelegate) => true;
}