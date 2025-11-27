import 'package:flutter/foundation.dart';

class FoodItem {
  final int? id;
  final String name;
  final double price;

  FoodItem({this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
  };

  factory FoodItem.fromMap(Map<String, dynamic> map) => FoodItem(
    id: map['id'] as int?,
    name: map['name'] as String,
    price: (map['price'] as num).toDouble(),
  );
}

class OrderPlan {
  final int? id;
  final String date; // "YYYY-MM-DD"
  final double targetCost;

  OrderPlan({this.id, required this.date, required this.targetCost});

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date,
    'target_cost': targetCost,
  };

  factory OrderPlan.fromMap(Map<String, dynamic> map) => OrderPlan(
    id: map['id'] as int?,
    date: map['date'] as String,
    targetCost: (map['target_cost'] as num).toDouble(),
  );
}

class PlanItem {
  final int? id;
  final int planId;
  final int foodItemId;
  final int quantity;

  PlanItem({
    this.id,
    required this.planId,
    required this.foodItemId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'plan_id': planId,
    'food_item_id': foodItemId,
    'quantity': quantity,
  };

  factory PlanItem.fromMap(Map<String, dynamic> map) => PlanItem(
    id: map['id'] as int?,
    planId: map['plan_id'] as int,
    foodItemId: map['food_item_id'] as int,
    quantity: map['quantity'] as int,
  );
}

@immutable
class PlanWithItems {
  final OrderPlan plan;
  final List<(PlanItem, FoodItem)> items; // Dart record of joined rows
  final double totalCost;

  const PlanWithItems({
    required this.plan,
    required this.items,
    required this.totalCost,
  });
}
