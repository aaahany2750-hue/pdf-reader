import 'package:flutter/material.dart';

class EmptySection extends StatelessWidget {
  const EmptySection({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
