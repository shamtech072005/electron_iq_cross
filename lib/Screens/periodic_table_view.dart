// lib/Screens/periodic_table_view.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../Datas/periodic_table_data.dart';
import '../Widgets/science_background_painter.dart';
import 'element_details_screen.dart';

class PeriodicTableView extends StatefulWidget {
  const PeriodicTableView({super.key});

  @override
  State<PeriodicTableView> createState() => _PeriodicTableViewState();
}

class _PeriodicTableViewState extends State<PeriodicTableView> {
  late List<ChemicalElement> _filteredElements;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredElements = periodicTableElements;
    _searchController.addListener(_filterElements);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterElements() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredElements = periodicTableElements.where((element) {
        final nameMatches = element.name.toLowerCase().contains(query);
        final symbolMatches = element.symbol.toLowerCase().contains(query);
        final numberMatches = element.atomicNumber.toString().contains(query);
        return nameMatches || symbolMatches || numberMatches;
      }).toList();
    });
  }

  AppBar _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        backgroundColor: const Color(0xFF112240), // Dark card color for search
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search by name, symbol, or number...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: () => _searchController.clear(),
          ),
        ],
      );
    } else {
      return AppBar(
        title: const Text('Periodic Table'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          const ScienceBackground(),
          InteractiveViewer(
            maxScale: 10.0,
            minScale: 0.8,
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double availableWidth = constraints.maxWidth;
                  final double availableHeight = constraints.maxHeight;
                  final double tileWidth = availableWidth / 18;
                  final double tileHeight = availableHeight / 10;
                  final double tileSize = min(tileWidth, tileHeight);
                  final double tableWidth = tileSize * 18;
                  final double tableHeight = tileSize * 10;

                  return SizedBox(
                    width: tableWidth,
                    height: tableHeight,
                    child: AnimationLimiter(
                      child: Stack(
                        children: [
                          ..._filteredElements.asMap().entries.map((entry) {
                            int index = entry.key;
                            ChemicalElement element = entry.value;
                            return ElementTile(
                              element: element,
                              tileSize: tileSize,
                              animationIndex: index,
                            );
                          }).toList(),
                          PlaceholderTile(
                            group: 3,
                            period: 6,
                            label: '57-71',
                            tileSize: tileSize,
                          ),
                          PlaceholderTile(
                            group: 3,
                            period: 7,
                            label: '89-103',
                            tileSize: tileSize,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ElementTile extends StatelessWidget {
  final ChemicalElement element;
  final double tileSize;
  final int animationIndex;

  const ElementTile({
    required this.element,
    required this.tileSize,
    required this.animationIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int displayGroup;
    double displayPeriod;

    if (element.atomicNumber >= 57 && element.atomicNumber <= 71) {
      displayPeriod = 8.5;
      displayGroup = (element.atomicNumber - 57) + 3;
    } else if (element.atomicNumber >= 89 && element.atomicNumber <= 103) {
      displayPeriod = 9.5;
      displayGroup = (element.atomicNumber - 89) + 3;
    } else {
      displayPeriod = element.period.toDouble();
      displayGroup = element.group;
    }

    return Positioned(
      top: (displayPeriod - 1) * tileSize,
      left: (displayGroup - 1) * tileSize,
      width: tileSize,
      height: tileSize,
      child: AnimationConfiguration.staggeredList(
        position: animationIndex,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ElementDetailsScreen(element: element),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: categoryColors[element.category] ?? Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          element.atomicNumber.toString(),
                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white70),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          element.symbol,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          element.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 7, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceholderTile extends StatelessWidget {
  final int group;
  final int period;
  final String label;
  final double tileSize;

  const PlaceholderTile({
    required this.group,
    required this.period,
    required this.label,
    required this.tileSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (period - 1) * tileSize,
      left: (group - 1) * tileSize,
      width: tileSize,
      height: tileSize,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: const Color(0xFF112240).withOpacity(0.5), // Match dark theme
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white38, fontSize: tileSize * 0.25),
          ),
        ),
      ),
    );
  }
}