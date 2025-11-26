import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderPlanScreen extends StatefulWidget {
  const OrderPlanScreen({super.key});

  @override
  State<OrderPlanScreen> createState() => _OrderPlanScreenState();
}

class _OrderPlanScreenState extends State<OrderPlanScreen> {
  double targetCost = 20.0;
  DateTime selectedDate = DateTime.now();

  // Sample food items (replace with DB later)
  final Map<String, double> foodItems = {
    'Chicken Wrap': 8.99,
    'Veggie Salad': 7.49,
    'Beef Burger': 10.99,
    'Fruit Bowl': 5.25,
    'Pasta Alfredo': 12.00,
    'Sushi Roll': 9.75,
    'Avocado Toast': 6.25,
    'Quinoa Bowl': 8.50,
    'Taco Trio': 11.00,
    'Pho Noodle Soup': 12.25,
  };

  final Map<String, bool> selectedItems = {};

  @override
  void initState() {
    super.initState();
    for (var item in foodItems.keys) {
      selectedItems[item] = false;
    }
  }

  double get totalCost {
    double sum = 0;
    selectedItems.forEach((item, selected) {
      if (selected) sum += foodItems[item]!;
    });
    return sum;
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _savePlan() {
    if (totalCost > targetCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Total exceeds target cost!')),
      );
      return;
    }

    // TODO: Connect to database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Plan saved for ${DateFormat('yyyy-MM-dd').format(selectedDate)} '
              'with total \$${totalCost.toStringAsFixed(2)}',
        ),
      ),
    );
  }

  // Drawer for navigation
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text('Food Ordering App',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          ListTile(
            title: const Text('Order Plan'),
            onTap: () => Navigator.pushReplacementNamed(context, '/plan'),
          ),
          ListTile(
            title: const Text('Query Plan'),
            onTap: () => Navigator.pushReplacementNamed(context, '/query'),
          ),
          ListTile(
            title: const Text('Manage Foods'),
            onTap: () => Navigator.pushReplacementNamed(context, '/manage'),
          ),
          ListTile(
            title: const Text('Food List'),
            onTap: () => Navigator.pushReplacementNamed(context, '/foods'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overBudget = totalCost > targetCost;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Plan')),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Target cost + date picker
            Row(children: [
              Expanded(
                child: TextFormField(
                  initialValue: targetCost.toStringAsFixed(2),
                  decoration: const InputDecoration(labelText: 'Target Cost'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) {
                      setState(() => targetCost = parsed);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _pickDate,
                child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
              ),
            ]),
            const SizedBox(height: 16),

            // Food selection list
            Expanded(
              child: ListView(
                children: foodItems.entries.map((entry) {
                  final name = entry.key;
                  final cost = entry.value;
                  final selected = selectedItems[name]!;
                  return CheckboxListTile(
                    title: Text('$name — \$${cost.toStringAsFixed(2)}'),
                    value: selected,
                    onChanged: (val) {
                      setState(() => selectedItems[name] = val ?? false);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Total + Save button
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: \$${totalCost.toStringAsFixed(2)} / '
                        '\$${targetCost.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: overBudget ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: overBudget ? null : _savePlan,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Plan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
