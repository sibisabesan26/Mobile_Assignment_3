import 'package:flutter/material.dart';
import '../../data/models.dart';

class FoodItemTile extends StatelessWidget {
  final FoodItem item;
  final void Function()? onEdit;
  final void Function()? onDelete;

  const FoodItemTile({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null)
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
