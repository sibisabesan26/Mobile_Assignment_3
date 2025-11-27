import 'package:flutter/material.dart';
import 'food_catalog_page.dart';
import 'plan_builder_page.dart';
import 'plan_view_page.dart';
import 'manage_food_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Ordering')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FoodCatalogPage()),
              ),
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Food Catalog'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageFoodPage()),
              ),
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Manage Food Items'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlanBuilderPage()),
              ),
              icon: const Icon(Icons.playlist_add),
              label: const Text('Build Order Plan'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlanViewPage()),
              ),
              icon: const Icon(Icons.search),
              label: const Text('View Order Plan by Date'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
