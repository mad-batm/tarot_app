import 'package:flutter/material.dart';
import 'spread_selection_screen.dart';
import 'virtual_deck_screen.dart';

void main() {
  runApp(TarotApp());
}

class TarotApp extends StatelessWidget {
  const TarotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarot App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Гадание на Таро'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpreadSelectionPage()),
                );
              },
              child: const Text('Выбрать расклад'),
            ),
            SizedBox(height: 20), // Отступ между кнопками
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VirtualDeckScreen()),
                );
              },
              child: const Text('Открыть виртуальную колоду'),
            ),
          ],
        ),
      ),
    );
  }
}
