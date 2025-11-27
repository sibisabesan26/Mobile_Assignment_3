import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const DateField({super.key, required this.controller, this.label = 'Date'});

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  final _fmt = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(now.year - 1),
          lastDate: DateTime(now.year + 2),
        );
        if (picked != null) {
          widget.controller.text = _fmt.format(picked);
        }
      },
      validator: (value) {
        if ((value ?? '').isEmpty) return 'Pick a date';
        return null;
      },
    );
  }
}
