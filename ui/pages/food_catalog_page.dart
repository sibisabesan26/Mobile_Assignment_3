import 'package:flutter/material.dart';
import '../../data/repositories.dart';
import '../../data/models.dart';
import '../widgets/food_item_tile.dart';

class FoodCatalogPage extends StatefulWidget {
  const FoodCatalogPage({super.key});

  @override
  State<FoodCatalogPage> createState() => _FoodCatalogPageState();
}

class _FoodCatalogPageState extends State<FoodCatalogPage> {
  final repo = FoodRepository();
  late Future<List<FoodItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = repo.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Catalog'),
        automaticallyImplyLeading: false, // 👈 disables default back arrow
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white), // 👈 your custom icon
          onPressed: () {
            Navigator.pop(context); // or Navigator.pushReplacement to go HomePage
          },
        ),
      ),

      body: FutureBuilder<List<FoodItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => FoodItemTile(item: items[i]),
          );
        },
      ),
    );
  }
}
