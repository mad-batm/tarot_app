import 'package:flutter/material.dart';

class SpreadDetailPage extends StatelessWidget {
  final String spreadTitle; // Название расклада
  final String spreadDescription; // Описание расклада

  const SpreadDetailPage({
    super.key,
    required this.spreadTitle,
    required this.spreadDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spreadTitle), // Заголовок расклада
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spreadTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              spreadDescription,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
