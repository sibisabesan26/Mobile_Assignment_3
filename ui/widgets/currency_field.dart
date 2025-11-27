import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  CurrencyField({super.key, required this.controller, this.label = 'Target cost'}) {
    if (controller.text.isEmpty) controller.text = '';
  }

  final _fmt = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: '\$',
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final v = double.tryParse((value ?? '').trim());
        if (v == null || v < 0) return 'Enter a valid non-negative amount';
        return null;
      },
    );
  }
}
