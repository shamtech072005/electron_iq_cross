// lib/Screens/comparison_selection_screen.dart

import 'package:flutter/material.dart';
import '../../../Datas/periodic_table_data.dart';
import 'comparison_results_screen.dart'; // We will create this next

class ComparisonSelectionScreen extends StatefulWidget {
  const ComparisonSelectionScreen({super.key});

  @override
  State<ComparisonSelectionScreen> createState() => _ComparisonSelectionScreenState();
}

class _ComparisonSelectionScreenState extends State<ComparisonSelectionScreen> {
  ChemicalElement? _element1;
  ChemicalElement? _element2;

  // Function to show the element picker dialog
  Future<void> _selectElement(int slot) async {
    final selectedElement = await showDialog<ChemicalElement>(
      context: context,
      builder: (context) => const ElementPickerDialog(),
    );

    if (selectedElement != null) {
      setState(() {
        if (slot == 1) {
          _element1 = selectedElement;
        } else {
          _element2 = selectedElement;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canCompare = _element1 != null && _element2 != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Elements'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildElementSlot(1, _element1),
                _buildElementSlot(2, _element2),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.compare_arrows_rounded),
              label: const Text('Compare'),
              onPressed: canCompare
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComparisonResultsScreen(
                            element1: _element1!,
                            element2: _element2!,
                          ),
                        ),
                      );
                    }
                  : null, // Button is disabled if not both elements are selected
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementSlot(int slot, ChemicalElement? element) {
    return Expanded(
      child: InkWell(
        onTap: () => _selectElement(slot),
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
              )
            ],
          ),
          child: element == null
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline_rounded, size: 60, color: Colors.cyan),
                      SizedBox(height: 16),
                      Text('Tap to Select', style: TextStyle(fontSize: 18, color: Colors.black54)),
                    ],
                  ),
                )
              : _buildElementCard(element),
        ),
      ),
    );
  }

  // A small card to display the selected element
  Widget _buildElementCard(ChemicalElement element) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          element.atomicNumber.toString(),
          style: TextStyle(fontSize: 24, color: Colors.grey[600]),
        ),
        Text(
          element.symbol,
          style: TextStyle(fontSize: 90, fontWeight: FontWeight.w900, color: categoryColors[element.category]),
        ),
        Text(
          element.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// --- The Searchable Dialog for Picking an Element ---
class ElementPickerDialog extends StatefulWidget {
  const ElementPickerDialog({super.key});

  @override
  State<ElementPickerDialog> createState() => _ElementPickerDialogState();
}

class _ElementPickerDialogState extends State<ElementPickerDialog> {
  late List<ChemicalElement> _filteredElements;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredElements = periodicTableElements;
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredElements = periodicTableElements.where((element) {
        return element.name.toLowerCase().contains(query) ||
               element.symbol.toLowerCase().contains(query) ||
               element.atomicNumber.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Select an Element'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredElements.length,
                itemBuilder: (context, index) {
                  final element = _filteredElements[index];
                  return ListTile(
                    leading: Text(
                      element.atomicNumber.toString(),
                      style: TextStyle(color: categoryColors[element.category], fontWeight: FontWeight.bold),
                    ),
                    title: Text(element.name),
                    onTap: () {
                      Navigator.pop(context, element); // Return the selected element
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}