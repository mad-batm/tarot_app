import 'package:flutter/material.dart';

class VirtualDeckScreen extends StatefulWidget {
  const VirtualDeckScreen({super.key});

  @override
  _VirtualDeckScreenState createState() => _VirtualDeckScreenState();
}

class _VirtualDeckScreenState extends State<VirtualDeckScreen> {
  List<String> deck = [
    // Старшие арканы
    'shut', 'mag', 'zhrica', 'impress', 'imperor',
    'hierofant', 'lovers', 'chariot', 'strenghch', 'hermit',
    'fortune', 'justise', 'hanged', 'death',
    'temperam', 'devil', 'tower', 'stare', 'moon',
    'sun', 'sud', 'world',

    // Жезлы
    'wands01', 'wands02', 'wands03', 'wands04',
    'wands05', 'wands06', 'wands07', 'wands08',
    'wands09', 'wands10', 'wands11', 'wands12',
    'wands13', 'wands14',

    // Кубки
    'cups01', 'cups02', 'cups03', 'cups04',
    'cups05', 'cups06', 'cups07', 'cups08',
    'cups09', 'cups10', 'cups11', 'cups12',
    'cups13', 'cups14',

    // Мечи
    'swords01', 'swords02', 'swords03', 'swords04',
    'swords05', 'swords06', 'swords07', 'swords08',
    'swords09', 'swords10', 'swords11', 'swords12',
    'swords13', 'swords14',

    // Пентакли
    'pents01', 'pents02', 'pents03',
    'pents04',
    'pents05', 'pents06', 'pents07',
    'pents08',
    'pents09', 'pents10', 'pents11',
    'pents12',
    'pents13', 'pents14',
  ];

  // Функция для перемешивания колоды
  void shuffleDeck() {
    setState(() {
      deck.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Виртуальная колода'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 столбца
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: deck.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/${deck[index]}.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      deck[index].replaceAll('_', ' ').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: shuffleDeck,
        child: const Icon(Icons.shuffle),
      ),
    );
  }
}
