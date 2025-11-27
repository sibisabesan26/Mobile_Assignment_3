import 'package:flutter/material.dart';
import '../../data/models.dart';
import '../../data/repositories.dart';
import '../widgets/food_item_tile.dart';

class ManageFoodPage extends StatefulWidget {
  const ManageFoodPage({super.key});

  @override
  State<ManageFoodPage> createState() => _ManageFoodPageState();
}

class _ManageFoodPageState extends State<ManageFoodPage> {
  final repo = FoodRepository();
  List<FoodItem> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await repo.getAll();
    setState(() {
      items = data;
      loading = false;
    });
  }

  Future<void> _showEditDialog({FoodItem? existing}) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final priceCtrl =
    TextEditingController(text: existing?.price.toString() ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Add food item' : 'Update food item'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final d = double.tryParse((v ?? '').trim());
                  if (d == null || d < 0) return 'Enter a non-negative price';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () {
            if (formKey.currentState!.validate()) Navigator.pop(context, true);
          }, child: const Text('Save')),
        ],
      ),
    );

    if (result == true) {
      final item = FoodItem(
        id: existing?.id,
        name: nameCtrl.text.trim(),
        price: double.parse(priceCtrl.text.trim()),
      );
      if (existing == null) {
        await repo.insert(item);
      } else {
        await repo.update(item);
      }
      await _load();
    }
  }

  Future<void> _deleteItem(FoodItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete item'),
        content: Text('Delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await repo.delete(item.id!);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage food items')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),
        child: const Icon(Icons.add, color: Colors.green),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) => FoodItemTile(
          item: items[i],
          onEdit: () => _showEditDialog(existing: items[i]),
          onDelete: () => _deleteItem(items[i]),
        ),
      ),
    );
  }
}
