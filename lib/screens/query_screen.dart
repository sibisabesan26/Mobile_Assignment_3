import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen({super.key});

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  DateTime selectedDate = DateTime.now();
  final Map<String, List<Map<String, dynamic>>> savedPlans = {
    '2025-11-20': [
      {'name': 'Chicken Wrap', 'cost': 8.99},
      {'name': 'Veggie Salad', 'cost': 7.49},
    ],
  };
  List<Map<String, dynamic>>? result;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _searchPlan() {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() => result = savedPlans[key]);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Query Plan')),
      drawer: const AppDrawer(),   // ✅ added here
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              ElevatedButton(onPressed: _pickDate, child: Text(dateStr)),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _searchPlan, child: const Text('Search')),
            ]),
            const SizedBox(height: 16),
            if (result == null)
              const Text('No results yet. Pick a date and search.')
            else if (result!.isEmpty)
              const Text('No plan found for this date.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: result!.length,
                  itemBuilder: (ctx, i) {
                    final item = result![i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.fastfood, color: Colors.green),
                        title: Text(item['name']),
                        subtitle: Text('\$${item['cost'].toStringAsFixed(2)}'),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
