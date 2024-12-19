import 'package:flutter/material.dart';
import 'dart:math';

class SpreadThreeCards extends StatefulWidget {
  const SpreadThreeCards({super.key});

  @override
  _SpreadThreeCardsState createState() => _SpreadThreeCardsState();
}

class _SpreadThreeCardsState extends State<SpreadThreeCards>
    with SingleTickerProviderStateMixin {
  final List<String> deck = [
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

  List<String> selectedCards = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _generateThreeCards();
  }

  void _generateThreeCards() {
    final random = Random();
    setState(() {
      selectedCards = List.from(deck)..shuffle(random);
      selectedCards = selectedCards.take(3).toList();
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Три карты'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Этот расклад покажет прошлое, настоящее и будущее.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(selectedCards.length, (index) {
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final offset = Offset(0, 100 * (1 - _animation.value));
                    return Transform.translate(
                      offset: offset,
                      child: Opacity(
                        opacity: _animation.value,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/${selectedCards[index]}.jpg',
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                              key: ValueKey(selectedCards[index]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 20), // Отступ между картами и кнопкой
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Отступ снизу
            child: ElevatedButton(
              onPressed: _generateThreeCards,
              child: const Text('Перетасовать карты'),
            ),
          ),
        ],
      ),
    );
  }
}
