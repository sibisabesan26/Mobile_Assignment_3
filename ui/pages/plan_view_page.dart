import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/repositories.dart';

class PlanViewPage extends StatefulWidget {
  const PlanViewPage({super.key});

  @override
  State<PlanViewPage> createState() => _PlanViewPageState();
}

class _PlanViewPageState extends State<PlanViewPage> {
  final planRepo = PlanRepository();
  final dateCtrl =
  TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  bool loading = false;
  String? error;
  String? summary;
  List<Map<String, dynamic>>? items;

  Future<void> _query() async {
    setState(() {
      loading = true;
      error = null;
      summary = null;
      items = null;
    });

    final date = dateCtrl.text.trim();
    final planWithItems = await planRepo.getPlanWithItemsByDate(date);
    if (planWithItems == null) {
      setState(() {
        loading = false;
        error = 'No plan found for $date';
      });
      return;
    }

    setState(() {
      loading = false;
      summary =
      'Date: ${planWithItems.plan.date} • Target: \$${planWithItems.plan.targetCost.toStringAsFixed(2)} • Total: \$${planWithItems.totalCost.toStringAsFixed(2)}';
      items = planWithItems.items
          .map((r) => {
        'name': r.$2.name,
        'price': r.$2.price,
        'quantity': r.$1.quantity,
        'lineTotal': r.$2.price * r.$1.quantity,
      })
          .toList();
    });
  }

  Future<void> _delete() async {
    final date = dateCtrl.text.trim();
    final count = await planRepo.deletePlanByDate(date);
    if (count > 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Deleted plan for $date')));
      setState(() {
        summary = null;
        items = null;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No plan to delete')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View order plan by date')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              controller: dateCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(now.year - 1),
                  lastDate: DateTime(now.year + 2),
                );
                if (picked != null) {
                  dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _query,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete plan'),
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (loading) const LinearProgressIndicator(),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            if (summary != null) Text(summary!, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: items == null
                  ? const SizedBox.shrink()
                  : ListView.separated(
                itemCount: items!.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final row = items![i];
                  return ListTile(
                    title: Text(row['name'] as String),
                    subtitle: Text(
                        'x${row['quantity']} • \$${(row['price'] as double).toStringAsFixed(2)} each'),
                    trailing: Text(
                      '\$${(row['lineTotal'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
