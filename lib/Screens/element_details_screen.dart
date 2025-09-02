// lib/Screens/element_details_screen.dart

import 'package:electron_iq/Widgets/aufbau_diagram_widget.dart' show AufbauDiagramWidget;
import 'package:flutter/material.dart';
import '../Datas/periodic_table_data.dart';
import '../Widgets/atom_animation_widget.dart';
import '../Widgets/bohr_model_widget.dart';
import '../Widgets/subshell_config_widget.dart' show SubshellConfigWidget;
import '../Widgets/valence_atom_animation_widget.dart';
import '../Widgets/science_background_painter.dart'; // <-- 1. Import the background

class ElementDetailsScreen extends StatelessWidget {
  final ChemicalElement element;

  const ElementDetailsScreen({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(element.name),
        backgroundColor: const Color(0xFF112240),
      ),
      // 2. Use a Stack to layer the background and the content
      body: Stack(
        children: [
          // The first item in the stack is the background
          const ScienceBackground(),

          // The second item is your scrollable list of element details
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Main atom animation card
              Card(
                clipBehavior: Clip.antiAlias,
                color: categoryColors[element.category]?.withOpacity(0.2),
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.landscape) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: _buildElementStaticInfo(),
                          ),
                          Expanded(
                            flex: 4,
                            child: AtomAnimationWidget(element: element),
                          ),
                        ],
                      );
                    } else {
                      return AtomAnimationWidget(element: element);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              _buildInfoCard(
                title: 'Electronic Configuration (Bohr Model)',
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: BohrModelWidget(element: element),
                ),
              ),
              const SizedBox(height: 16),
              
              _buildInfoCard(
                title: 'Subshell Configuration',
                child: SizedBox(
                  height: 220,
                  child: SubshellConfigWidget(element: element),
                ),
              ),
              const SizedBox(height: 16),
              
              _buildInfoCard(
                title: 'Aufbau Principle Structure',
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: AufbauDiagramWidget(element: element),
                ),
              ),
              const SizedBox(height: 16),

              _buildInfoCard(
                title: 'Valence Electrons (${element.electronConfiguration.last})',
                child: SizedBox(
                  height: 150,
                  child: ValenceAtomAnimationWidget(element: element),
                )
              ),
              const SizedBox(height: 16),

              _buildInfoCard(
                title: 'Summary',
                child: Text(
                  element.summary,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildInfoCard(
                title: 'Properties',
                child: Column(
                  children: [
                    _buildPropertyRow('Category', element.category.name.replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z])'), (match) => ' ${match.group(0)}')),
                    _buildPropertyRow('Atomic Mass', '${element.atomicMass.toStringAsFixed(3)} u'),
                    _buildPropertyRow('Block', element.block),
                    if (element.meltingPoint != null)
                      _buildPropertyRow('Melting Point', element.meltingPoint!),
                    if (element.density != null)
                      _buildPropertyRow('Density', element.density!),
                    _buildPropertyRow('Group', element.group.toString()),
                    _buildPropertyRow('Period', element.period.toString()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildElementStaticInfo() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            element.atomicNumber.toString(),
            style: const TextStyle(fontSize: 24, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            element.symbol,
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            element.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            '${element.atomicMass.toStringAsFixed(3)} u',
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Divider(height: 20, color: Colors.white24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
