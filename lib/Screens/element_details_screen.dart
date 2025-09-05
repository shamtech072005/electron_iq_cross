// lib/Screens/element_details_screen.dart

import 'package:electron_iq/Widgets/aufbau_diagram_widget.dart'
    show AufbauDiagramWidget;
import 'package:flutter/material.dart';
import '../Datas/periodic_table_data.dart';
import '../Widgets/atom_animation_widget.dart';
import '../Widgets/bohr_model_widget.dart';
import '../Widgets/subshell_config_widget.dart' show SubshellConfigWidget;
import '../Widgets/valence_atom_animation_widget.dart';
import '../Widgets/science_background_painter.dart';

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
      body: Stack(
        children: [
          const ScienceBackground(),
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
                          Expanded(flex: 5, child: _buildElementStaticInfo()),
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

              // ELEMENT IMAGE CARD
              if (element.imagePath != null)
                _buildInfoCard(
                  title: 'Visual Representation',
                  child: Center(
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 350, // Leave room for text
                              maxWidth: 400,
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  element.imagePath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.image_not_supported_rounded,
                                        size: 50,
                                        color: Colors.white24,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (element.imageTitle != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: 400,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                element.imageTitle!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              if (element.imagePath != null) const SizedBox(height: 16),

              // --- THIS IS THE FIX: Using larger aspect ratios to make cards shorter ---
              _buildInfoCard(
                title: 'Electronic Configuration (Bohr Model)',
                child: AspectRatio(
                  aspectRatio: 1.6, // Adjusted from 1.3
                  child: BohrModelWidget(element: element),
                ),
              ),
              const SizedBox(height: 16),

              _buildInfoCard(
                title: 'Subshell Configuration',
                child: AspectRatio(
                  aspectRatio: 1.8, // Adjusted from 1.5
                  child: SubshellConfigWidget(element: element),
                ),
              ),
              const SizedBox(height: 16),

              _buildInfoCard(
                title: 'Aufbau Principle Structure',
                child: AspectRatio(
                  aspectRatio: 1.4, // Adjusted from 1.2
                  child: AufbauDiagramWidget(element: element),
                ),
              ),
              const SizedBox(height: 16),

              _buildInfoCard(
                title:
                    'Valence Electrons (${element.electronConfiguration.last})',
                child: AspectRatio(
                  aspectRatio: 2.2, // Adjusted from 2.0
                  child: ValenceAtomAnimationWidget(element: element),
                ),
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
                    _buildPropertyRow(
                      'Category',
                      element.category.name.replaceAllMapped(
                        RegExp(r'(?<=[a-z])(?=[A-Z])'),
                        (match) => ' ${match.group(0)}',
                      ),
                    ),
                    _buildPropertyRow(
                      'Atomic Mass',
                      '${element.atomicMass.toStringAsFixed(3)} u',
                    ),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double sizeFactor = constraints.maxWidth / 300;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                element.atomicNumber.toString(),
                style: TextStyle(
                  fontSize: (24 * sizeFactor).clamp(16, 28),
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                element.symbol,
                style: TextStyle(
                  fontSize: (80 * sizeFactor).clamp(40, 90),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                element.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (28 * sizeFactor).clamp(18, 32),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${element.atomicMass.toStringAsFixed(3)} u',
                style: TextStyle(
                  fontSize: (18 * sizeFactor).clamp(14, 22),
                  color: Colors.white70,
                ),
              ),
            ],
          );
        },
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
            style: const TextStyle(fontSize: 16, color: Colors.white),
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
