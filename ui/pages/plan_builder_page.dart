import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models.dart';
import '../../data/repositories.dart';
import '../widgets/date_field.dart';
import '../widgets/currency_field.dart';

class PlanBuilderPage extends StatefulWidget {
  const PlanBuilderPage({super.key});

  @override
  State<PlanBuilderPage> createState() => _PlanBuilderPageState();
}

class _PlanBuilderPageState extends State<PlanBuilderPage> {
  final foodRepo = FoodRepository();
  final planRepo = PlanRepository();

  final dateCtrl = TextEditingController();
  final targetCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<FoodItem> catalog = [];
  final Map<int, int> quantities = {}; // foodItemId -> qty
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    dateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    targetCtrl.text = '20.00'; // Default target; editable
  }

  Future<void> _loadCatalog() async {
    final items = await foodRepo.getAll();
    setState(() => catalog = items);
  }

  void _recomputeTotal() {
    double sum = 0.0;
    for (final item in catalog) {
      final q = quantities[item.id ?? -1] ?? 0;
      sum += item.price * q;
    }
    setState(() => total = sum);
  }

  void _increment(FoodItem item) {
    final id = item.id!;
    quantities[id] = (quantities[id] ?? 0) + 1;
    _recomputeTotal();
  }

  void _decrement(FoodItem item) {
    final id = item.id!;
    final q = (quantities[id] ?? 0);
    if (q > 0) {
      quantities[id] = q - 1;
      if (quantities[id] == 0) quantities.remove(id);
      _recomputeTotal();
    }
  }

  Future<void> _savePlan() async {
    if (!formKey.currentState!.validate()) return;

    final target = double.parse(targetCtrl.text.trim());
    if (total > target) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Total \$${total.toStringAsFixed(2)} exceeds target \$${target.toStringAsFixed(2)}')),
      );
      return;
    }

    final date = dateCtrl.text.trim();
    final plan = await planRepo.upsertPlan(date, target);

    final items = <PlanItem>[];
    quantities.forEach((foodId, qty) {
      if (qty > 0) {
        items.add(PlanItem(planId: plan.id!, foodItemId: foodId, quantity: qty));
      }
    });
    await planRepo.replacePlanItems(plan.id!, items);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plan saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final target = double.tryParse(targetCtrl.text.trim()) ?? 0.0;
    final overBudget = total > target;

    return Scaffold(
      appBar: AppBar(title: const Text('Build order plan')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Row(
                children: [
                  Expanded(child: DateField(controller: dateCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: CurrencyField(controller: targetCtrl, label: 'Target per day')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: catalog.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                itemCount: catalog.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final item = catalog[i];
                  final q = quantities[item.id ?? -1] ?? 0;
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () => _decrement(item), icon: const Icon(Icons.remove)),
                        Text('$q'),
                        IconButton(onPressed: () => _increment(item), icon: const Icon(Icons.add)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Total: \$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: overBudget ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    )),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _savePlan,
                  icon: const Icon(Icons.save),
                  label: const Text('Save plan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
