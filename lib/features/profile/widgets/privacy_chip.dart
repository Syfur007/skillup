import 'package:flutter/material.dart';

class PrivacyChip extends StatelessWidget {
  final String label;
  final bool visible;
  const PrivacyChip(this.label, this.visible, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: Icon(
        visible ? Icons.visibility : Icons.visibility_off,
        size: 16,
      ),
      backgroundColor: visible ? Colors.green.withAlpha(25) : Colors.grey.withAlpha(25),
    );
  }
}

