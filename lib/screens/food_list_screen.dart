import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  // Sample food items (later connect to DB)
  final List<Map<String, dynamic>> foods = const [
    {'name': 'Chicken Wrap', 'cost': 8.99},
    {'name': 'Veggie Salad', 'cost': 7.49},
    {'name': 'Beef Burger', 'cost': 10.99},
    {'name': 'Fruit Bowl', 'cost': 5.25},
    {'name': 'Pasta Alfredo', 'cost': 12.00},
    {'name': 'Sushi Roll', 'cost': 9.75},
    {'name': 'Avocado Toast', 'cost': 6.25},
    {'name': 'Quinoa Bowl', 'cost': 8.50},
    {'name': 'Taco Trio', 'cost': 11.00},
    {'name': 'Pho Noodle Soup', 'cost': 12.25},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food List')),
      drawer: const AppDrawer(), // ✅ reusable drawer
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: foods.length,
        itemBuilder: (ctx, i) {
          final food = foods[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.green),
              title: Text(food['name']),
              subtitle: Text('\$${food['cost'].toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}
