import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ManageFoodScreen extends StatefulWidget {
  const ManageFoodScreen({super.key});

  @override
  State<ManageFoodScreen> createState() => _ManageFoodScreenState();
}

class _ManageFoodScreenState extends State<ManageFoodScreen> {
  final List<Map<String, dynamic>> _foods = [
    {'name': 'Chicken Wrap', 'cost': 8.99},
    {'name': 'Veggie Salad', 'cost': 7.49},
    {'name': 'Beef Burger', 'cost': 10.99},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  void _addFood() {
    final name = _nameController.text.trim();
    final cost = double.tryParse(_costController.text.trim());

    if (name.isEmpty || cost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid name and cost')),
      );
      return;
    }

    setState(() {
      _foods.add({'name': name, 'cost': cost});
    });

    _nameController.clear();
    _costController.clear();
  }

  void _editFood(int index) {
    _nameController.text = _foods[index]['name'];
    _costController.text = _foods[index]['cost'].toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Food'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _costController, decoration: const InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final cost = double.tryParse(_costController.text.trim());
              if (name.isNotEmpty && cost != null) {
                setState(() {
                  _foods[index] = {'name': name, 'cost': cost};
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteFood(int index) {
    setState(() {
      _foods.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Foods')),
      drawer: const AppDrawer(), // ✅ reusable drawer
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add food form
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: _costController,
              decoration: const InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addFood,
              icon: const Icon(Icons.add),
              label: const Text('Add Food'),
            ),
            const SizedBox(height: 16),

            // Food list
            Expanded(
              child: ListView.builder(
                itemCount: _foods.length,
                itemBuilder: (ctx, i) {
                  final food = _foods[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.fastfood, color: Colors.green),
                      title: Text(food['name']),
                      subtitle: Text('\$${food['cost'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editFood(i),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteFood(i),
                          ),
                        ],
                      ),
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
