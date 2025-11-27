import 'package:sqflite/sqflite.dart';
import 'database.dart';
import 'models.dart';

class FoodRepository {
  final AppDatabase _dbProvider = AppDatabase();

  Future<List<FoodItem>> getAll() async {
    final db = await _dbProvider.db;
    final rows = await db.query('food_items', orderBy: 'name ASC');
    return rows.map(FoodItem.fromMap).toList();
  }

  Future<FoodItem> insert(FoodItem food) async {
    final db = await _dbProvider.db;
    final id = await db.insert('food_items', food.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return FoodItem(id: id, name: food.name, price: food.price);
  }

  Future<int> update(FoodItem food) async {
    final db = await _dbProvider.db;
    return db.update('food_items', food.toMap(),
        where: 'id = ?', whereArgs: [food.id]);
  }

  Future<int> delete(int id) async {
    final db = await _dbProvider.db;
    return db.delete('food_items', where: 'id = ?', whereArgs: [id]);
  }
}

class PlanRepository {
  final AppDatabase _dbProvider = AppDatabase();

  Future<OrderPlan?> getByDate(String date) async {
    final db = await _dbProvider.db;
    final rows = await db.query('order_plans',
        where: 'date = ?', whereArgs: [date], limit: 1);
    if (rows.isEmpty) return null;
    return OrderPlan.fromMap(rows.first);
  }

  Future<PlanWithItems?> getPlanWithItemsByDate(String date) async {
    final db = await _dbProvider.db;
    final plan = await getByDate(date);
    if (plan == null) return null;

    final rows = await db.rawQuery('''
      SELECT pi.id as pi_id, pi.plan_id, pi.food_item_id, pi.quantity,
             fi.id as fi_id, fi.name, fi.price
      FROM plan_items pi
      JOIN food_items fi ON fi.id = pi.food_item_id
      WHERE pi.plan_id = ?
      ORDER BY fi.name ASC
    ''', [plan.id]);

    final items = rows.map((r) {
      final pi = PlanItem(
        id: r['pi_id'] as int?,
        planId: r['plan_id'] as int,
        foodItemId: r['food_item_id'] as int,
        quantity: r['quantity'] as int,
      );
      final fi = FoodItem(
        id: r['fi_id'] as int?,
        name: r['name'] as String,
        price: (r['price'] as num).toDouble(),
      );
      return (pi, fi);
    }).toList();

    final total = items.fold<double>(
        0.0, (sum, e) => sum + e.$2.price * e.$1.quantity);

    return PlanWithItems(plan: plan, items: items, totalCost: total);
  }

  Future<OrderPlan> upsertPlan(String date, double targetCost) async {
    final db = await _dbProvider.db;
    // Try find existing
    final existing = await db.query('order_plans',
        where: 'date = ?', whereArgs: [date], limit: 1);
    if (existing.isNotEmpty) {
      final id = existing.first['id'] as int;
      await db.update('order_plans', {
        'id': id,
        'date': date,
        'target_cost': targetCost,
      }, where: 'id = ?', whereArgs: [id]);
      return OrderPlan(id: id, date: date, targetCost: targetCost);
    } else {
      final id = await db.insert('order_plans', {
        'date': date,
        'target_cost': targetCost,
      });
      return OrderPlan(id: id, date: date, targetCost: targetCost);
    }
  }

  Future<void> replacePlanItems(int planId, List<PlanItem> items) async {
    final db = await _dbProvider.db;
    await db.transaction((txn) async {
      await txn.delete('plan_items', where: 'plan_id = ?', whereArgs: [planId]);
      final batch = txn.batch();
      for (final item in items) {
        batch.insert('plan_items', item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.abort);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<int> deletePlanByDate(String date) async {
    final db = await _dbProvider.db;
    final plan = await getByDate(date);
    if (plan == null) return 0;
    return db.delete('order_plans', where: 'id = ?', whereArgs: [plan.id]);
  }
}
