import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String currentDeckStyle;
  final Function(String) onDeckStyleChanged;

  const SettingsScreen({
    super.key,
    required this.currentDeckStyle,
    required this.onDeckStyleChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String selectedDeckStyle;

  @override
  void initState() {
    super.initState();
    selectedDeckStyle = widget.currentDeckStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выберите стиль колоды:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._buildDeckStyleOptions(),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                widget.onDeckStyleChanged(selectedDeckStyle);
                Navigator.pop(context);
              },
              child: const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDeckStyleOptions() {
    final styles = ['classic', 'durer']; // Добавьте свои стили

    return styles.map((style) {
      return RadioListTile<String>(
        title: Text(style),
        value: style,
        groupValue: selectedDeckStyle,
        onChanged: (value) {
          setState(() {
            selectedDeckStyle = value!;
          });
        },
      );
    }).toList();
  }
}
