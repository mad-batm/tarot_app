import 'package:flutter/material.dart';
import 'dart:math';

class SpreadLovePath extends StatefulWidget {
  const SpreadLovePath({super.key});

  @override
  _SpreadLovePathState createState() => _SpreadLovePathState();
}

class _SpreadLovePathState extends State<SpreadLovePath>
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

  late AnimationController _controller;
  late List<String> selectedCards;

  final List<Offset> cardPositions = [
    Offset(-0.7, -0.5),
    Offset(-0.4, 0),
    Offset(0.0, 0.5),
    Offset(0.4, 0),
    Offset(0.7, -0.5),
    Offset(0.0, -0.8),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _shuffleDeck();
    _controller.forward();
  }

  void _shuffleDeck() {
    final random = Random();
    setState(() {
      selectedCards = List.from(deck)..shuffle(random);
      selectedCards = selectedCards.take(cardPositions.length).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Путь любви'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Этот расклад анализирует отношения и их развитие.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: Stack(
                children: List.generate(
                  selectedCards.length,
                  (index) => _buildAnimatedCard(selectedCards[index], index),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                _controller.reset();
                _shuffleDeck();
                _controller.forward();
              },
              child: const Text('Перетасовать карты'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(String card, int index) {
    final animationPosition = Tween<Offset>(
      begin: Offset(0, 2), // Старт из нижней части экрана
      end: cardPositions[index], // Позиция из заранее заданного списка
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1, // Задержка для каждой карты
          min(1.0, index * 0.1 + 0.5),
          curve: Curves.easeOut,
        ),
      ),
    );

    final animationOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          min(1.0, index * 0.1 + 0.3),
          curve: Curves.easeIn,
        ),
      ),
    );

    final animationRotation = Tween<double>(
      begin: pi / 6, // Небольшой поворот
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          min(1.0, index * 0.1 + 0.5),
          curve: Curves.easeOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: animationOpacity.value,
          child: Transform.translate(
            offset:
                animationPosition.value * MediaQuery.of(context).size.width / 2,
            child: Transform.rotate(
              angle: animationRotation.value,
              child: _buildCard(card),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(String card) {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          'assets/images/$card.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
