// lib/Screens/element_details_screen.dart

import 'package:electron_iq/Features/Periodic%20Table/widgets/aufbau_diagram_widget.dart'
    show AufbauDiagramWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../Datas/periodic_table_data.dart';
import '../widgets/atom_animation_widget.dart';
import '../widgets/bohr_model_widget.dart';
import '../widgets/subshell_config_widget.dart' show SubshellConfigWidget;
import '../widgets/valence_atom_animation_widget.dart';
import '../../../Shared Widgets/Widgets/science_background_painter.dart';

class ElementDetailsScreen extends StatelessWidget {
  final ChemicalElement element;

  const ElementDetailsScreen({super.key, required this.element});

  // --- NEW: A centralized list of all the info cards ---
  List<Widget> _buildInfoCardsList() {
    const double cardHeight = 450; // Standard height for all cards

    return [
      _buildElementInfoCard(element: element), // This card has its own sizing
      SizedBox(
        height: cardHeight,
        child: _buildPropertiesCard(),
      ),
      SizedBox(
        height: cardHeight,
        child: _buildUsesCard(),
      ),
      if (element.imagePath != null)
        SizedBox(
          height: cardHeight,
          child: _buildVisualRepresentationCard(),
        ),
      SizedBox(
        height: cardHeight,
        child: _buildBohrModelCard(),
      ),
      SizedBox(
        height: cardHeight,
        child: _buildInfoCard(
          title: 'Subshell Configuration',
          child: SubshellConfigWidget(element: element),
        ),
      ),
      SizedBox(
        height: cardHeight,
        child: _buildAufbauDiagramCard(),
      ),
      SizedBox(
        height: cardHeight,
        child: _buildValenceElectronsCard(),
      ),
      SizedBox(
        height: cardHeight,
        child: _buildSummaryCard(),
      ),
    ];
  }

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
          LayoutBuilder(
            builder: (context, constraints) {
              if (kIsWeb && constraints.maxWidth > 1200) {
                return _buildWebLayout();
              }
              return OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return _buildPortraitLayout();
                  } else {
                    return _buildLandscapeLayout();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    final cards = _buildInfoCardsList();
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  Widget _buildLandscapeLayout() {
    final cards = _buildInfoCardsList();
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8, // Adjust aspect ratio for better look
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
    );
  }

  Widget _buildWebLayout() {
    final allCards = _buildInfoCardsList();
    final topCards = allCards.sublist(0, 2);
    final remainingCards = allCards.sublist(2);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 1, child: topCards[0]),
                  const SizedBox(width: 16),
                  Expanded(flex: 1, child: topCards[1]),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: remainingCards.length,
            itemBuilder: (context, index) => remainingCards[index],
          ),
        ),
      ],
    );
  }

  Widget _buildElementInfoCard({required ChemicalElement element}) {
    final int protons = element.atomicNumber;
    final int electrons = element.atomicNumber;
    final int neutrons = element.atomicMass.round() - element.atomicNumber;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: categoryColors[element.category],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      element.atomicNumber.toString(),
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      element.symbol,
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      element.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildParticleRow(
                      icon: Icons.add_circle,
                      label: 'Protons',
                      value: protons.toString(),
                      color: Colors.lightBlueAccent,
                    ),
                    _buildParticleRow(
                      icon: Icons.remove_circle,
                      label: 'Electrons',
                      value: electrons.toString(),
                      color: Colors.yellowAccent,
                    ),
                    _buildParticleRow(
                      icon: Icons.radio_button_unchecked_rounded,
                      label: 'Neutrons',
                      value: neutrons.toString(),
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticleRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualRepresentationCard() {
    return _buildInfoCard(
      title: 'Visual Representation',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
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
            if (element.imageTitle != null) ...[
              const SizedBox(height: 12),
              Text(
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
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBohrModelCard() {
    return _buildInfoCard(
      title: 'Electronic Configuration (Bohr Model)',
      child: BohrModelWidget(element: element),
    );
  }

  Widget _buildAufbauDiagramCard() {
    return _buildInfoCard(
      title: 'Aufbau Principle Structure',
      child: AufbauDiagramWidget(element: element),
    );
  }

  Widget _buildValenceElectronsCard() {
    return _buildInfoCard(
      title: 'Valence Electrons (${element.electronConfiguration.last})',
      child: ValenceAtomAnimationWidget(element: element),
    );
  }

  Widget _buildSummaryCard() {
    return _buildInfoCard(
      title: 'Summary',
      child: SingleChildScrollView(
        child: Text(
          element.summary,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPropertiesCard() {
    return _buildInfoCard(
      title: 'Properties',
      child: ListView(
        children: [
          _buildPropertyRow('Element Name', element.name),
          _buildPropertyRow('Symbol', element.symbol),
          _buildPropertyRow('Atomic Number', element.atomicNumber.toString()),
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
          _buildPropertyRow(
              'Electron Configuration', element.electronConfiguration.join(', ')),
        ],
      ),
    );
  }

  Widget _buildUsesCard() {
    String? imagePathToUse = element.realImagePath;
    if (imagePathToUse == null || imagePathToUse.isEmpty) {
      imagePathToUse = 'assets/Rimg/${element.symbol}_Rimg.png';
    }

    return _buildInfoCard(
      title: 'Uses & Applications',
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePathToUse,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.science_rounded,
                      size: 50,
                      color: categoryColors[element.category]?.withOpacity(0.5),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: element.uses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          element.uses[index],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 15,
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