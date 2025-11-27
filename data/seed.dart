import 'package:sqflite/sqflite.dart';

final _seedItems = <Map<String, dynamic>>[
  {'name': 'Chicken Wrap', 'price': 8.49},
  {'name': 'Veggie Burrito', 'price': 7.99},
  {'name': 'Beef Burger', 'price': 9.99},
  {'name': 'Caesar Salad', 'price': 6.50},
  {'name': 'Greek Salad', 'price': 7.25},
  {'name': 'Margherita Pizza Slice', 'price': 3.75},
  {'name': 'Pepperoni Pizza Slice', 'price': 4.25},
  {'name': 'Sushi Roll (California)', 'price': 5.99},
  {'name': 'Sushi Roll (Spicy Tuna)', 'price': 6.49},
  {'name': 'Pasta Alfredo', 'price': 10.50},
  {'name': 'Pasta Bolognese', 'price': 11.00},
  {'name': 'Falafel Plate', 'price': 8.75},
  {'name': 'Shawarma Plate', 'price': 10.25},
  {'name': 'Pad Thai', 'price': 12.00},
  {'name': 'Butter Chicken', 'price': 13.50},
  {'name': 'Tacos (2)', 'price': 7.50},
  {'name': 'Ramen Bowl', 'price': 12.75},
  {'name': 'Smoothie', 'price': 4.99},
  {'name': 'Iced Coffee', 'price': 3.50},
  {'name': 'Fruit Cup', 'price': 3.25},
  {'name': 'Soup of the Day', 'price': 5.25},
  {'name': 'Bagel with Cream Cheese', 'price': 2.99},
];

Future<void> seedIfEmpty(Database db) async {
  final count = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM food_items'),
  );
  if ((count ?? 0) == 0) {
    final batch = db.batch();
    for (final item in _seedItems) {
      batch.insert('food_items', item,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }
}
