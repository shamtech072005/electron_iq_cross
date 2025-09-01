// lib/Screens/comparison_results_screen.dart

import 'package:flutter/material.dart';
import '../Datas/periodic_table_data.dart';

class ComparisonResultsScreen extends StatelessWidget {
  final ChemicalElement element1;
  final ChemicalElement element2;

  const ComparisonResultsScreen({
    super.key,
    required this.element1,
    required this.element2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${element1.name} vs ${element2.name}'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header row with element symbols
          Row(
            children: [
              _buildHeaderCell(element1),
              const SizedBox(width: 80, child: Center(child: Text('Property', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)))),
              _buildHeaderCell(element2),
            ],
          ),
          const Divider(thickness: 2),

          // Property rows
          _buildComparisonRow('Atomic Number', element1.atomicNumber.toString(), element2.atomicNumber.toString()),
          _buildComparisonRow('Atomic Mass', element1.atomicMass.toStringAsFixed(3), element2.atomicMass.toStringAsFixed(3)),
          _buildComparisonRow('Category', element1.category.name, element2.category.name),
          _buildComparisonRow('Block', element1.block, element2.block),
          _buildComparisonRow('Group', element1.group.toString(), element2.group.toString()),
          _buildComparisonRow('Period', element1.period.toString(), element2.period.toString()),
          _buildComparisonRow('Melting Point', element1.meltingPoint ?? 'N/A', element2.meltingPoint ?? 'N/A'),
          _buildComparisonRow('Density', element1.density ?? 'N/A', element2.density ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(ChemicalElement element) {
    return Expanded(
      child: Column(
        children: [
          Text(
            element.symbol,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: categoryColors[element.category],
            ),
          ),
          Text(
            element.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String property, String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(child: Text(value1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16))),
          SizedBox(
            width: 80,
            child: Center(
              child: Text(property, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
            ),
          ),
          Expanded(child: Text(value2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}