import 'package:flutter/material.dart';
import 'dart:math';

class SpreadCelticCross extends StatefulWidget {
  const SpreadCelticCross({super.key});

  @override
  _SpreadCelticCrossState createState() => _SpreadCelticCrossState();
}

class _SpreadCelticCrossState extends State<SpreadCelticCross> {
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
  List<bool> cardVisible = List.generate(10, (_) => false);

  @override
  void initState() {
    super.initState();
    _generateCelticCross();
  }

  void _generateCelticCross() async {
    setState(() {
      // Перемешиваем колоду и берем первые 10 карт
      List<String> shuffledDeck = List.from(deck);
      shuffledDeck.shuffle();
      selectedCards = shuffledDeck.take(10).toList();
      cardVisible = List.generate(10, (_) => false); // Скрываем карты
    });

    // Показываем карты с задержкой
    for (int i = 0; i < selectedCards.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        cardVisible[i] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расклад: Кельтский крест'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Кельтский крест — это детальный анализ ситуации с 10 картами.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Центральные карты с анимацией
                _buildAnimatedCard(150, 120, selectedCards[0], cardVisible[0]),
                _buildAnimatedCard(150, 120, selectedCards[1], cardVisible[1],
                    rotation: pi / 2),
                // Карты вокруг центра
                _buildAnimatedCard(
                    30, 120, selectedCards[2], cardVisible[2]), // Над центром
                _buildAnimatedCard(
                    270, 120, selectedCards[3], cardVisible[3]), // Под центром
                _buildAnimatedCard(
                    150, 20, selectedCards[4], cardVisible[4]), // Слева
                _buildAnimatedCard(
                    150, 220, selectedCards[5], cardVisible[5]), // Справа
                // Вертикальные карты справа
                _buildAnimatedCard(50, 300, selectedCards[6], cardVisible[6]),
                _buildAnimatedCard(150, 300, selectedCards[7], cardVisible[7]),
                _buildAnimatedCard(250, 300, selectedCards[8], cardVisible[8]),
                _buildAnimatedCard(350, 300, selectedCards[9], cardVisible[9]),
              ],
            ),
          ),
          const SizedBox(height: 20), // Отступ между картами и кнопкой
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Отступ снизу
            child: ElevatedButton(
              onPressed: _generateCelticCross,
              child: const Text('Перетасовать карты'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(
      double top, double left, String cardName, bool isVisible,
      {double rotation = 0}) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: TweenAnimationBuilder(
          tween: Tween<Offset>(
            begin: const Offset(0, 0),
            end: const Offset(0, 0), // Можно добавить изменения позиции здесь
          ),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Transform.translate(
              offset: value,
              child: Transform.rotate(
                angle: rotation,
                child: child,
              ),
            );
          },
          child: _buildCard(cardName),
        ),
      ),
    );
  }

  Widget _buildCard(String cardName) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.black26)],
      ),
      child: Image.asset(
        'assets/images/$cardName.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
