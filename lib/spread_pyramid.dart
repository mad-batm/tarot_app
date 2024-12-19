import 'package:flutter/material.dart';
import 'dart:math';

class SpreadPyramid extends StatefulWidget {
  const SpreadPyramid({super.key});

  @override
  _SpreadPyramidState createState() => _SpreadPyramidState();
}

class _SpreadPyramidState extends State<SpreadPyramid>
    with SingleTickerProviderStateMixin {
  final List<String> deck = [
    // Карты (для упрощения часть опущена)
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Общая длительность анимации
    );
    _generatePyramidCards();
    _controller.forward(); // Запускаем анимацию при загрузке
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generatePyramidCards() {
    final random = Random();
    setState(() {
      selectedCards = List.from(deck)..shuffle(random);
      selectedCards = selectedCards.take(6).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пирамида'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Этот расклад показывает подробный анализ выбора и результата.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          // Верхний уровень пирамиды (Карта 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedCard(0, -0.6, selectedCards[0], 0),
            ],
          ),
          // Второй уровень пирамиды (Карты 2 и 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedCard(-0.5, 0, selectedCards[1], 1),
              _buildAnimatedCard(0.5, 0, selectedCards[2], 2),
            ],
          ),
          // Нижний уровень пирамиды (Карты 4, 5, 6)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedCard(-0.8, 0.6, selectedCards[3], 3),
              _buildAnimatedCard(0, 0.6, selectedCards[4], 4),
              _buildAnimatedCard(0.8, 0.6, selectedCards[5], 5),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Отступ снизу
            child: ElevatedButton(
              onPressed: () {
                _generatePyramidCards();
                _controller.forward(from: 0); // Перезапускаем анимацию
              },
              child: const Text('Перетасовать карты'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(
      double xAlign, double yAlign, String card, int index) {
    // Задаем интервал для каждой карты
    final animationInterval = Interval(
      index * 0.15, // Смещение появления каждой карты
      min(index * 0.15 + 0.6, 1.0), // Общая длительность одной карты
      curve: Curves.easeOut,
    );

    final animationOpacity = _controller.drive(
      CurveTween(curve: animationInterval),
    );

    final animationScale = _controller.drive(
      Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: animationInterval)),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: animationOpacity.value,
          child: Transform.scale(
            scale: animationScale.value,
            child: _buildCard(card, xAlign, yAlign),
          ),
        );
      },
    );
  }

  Widget _buildCard(String card, double xAlign, double yAlign) {
    return Align(
      alignment: Alignment(xAlign, yAlign),
      child: Container(
        width: 100,
        height: 150,
        margin: const EdgeInsets.all(8.0),
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
      ),
    );
  }
}
