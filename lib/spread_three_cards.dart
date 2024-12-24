import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart'; // Импортируем provider
import 'change_notifier.dart'; // Импортируем DeckProvider

class SpreadThreeCards extends StatefulWidget {
  const SpreadThreeCards({super.key});

  @override
  _SpreadThreeCardsState createState() => _SpreadThreeCardsState();
}

class _SpreadThreeCardsState extends State<SpreadThreeCards>
    with SingleTickerProviderStateMixin {
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
    _generateThreeCards(); // Инициализация карт
  }

  void _generateThreeCards() {
    // Получаем текущую колоду из провайдера
    final deck = Provider.of<DeckProvider>(context, listen: false).currentDeck;
    final random = Random();
    setState(() {
      selectedCards = List.from(deck)..shuffle(random);
      selectedCards = selectedCards.take(3).toList(); // Берем первые 3 карты
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
    final imagePath = Provider.of<DeckProvider>(context)
        .currentDeckImagePath; // Путь к изображениям

    return Scaffold(
      appBar: AppBar(
        title: const Text('Три карты'),
      ),
      body: StarryBackground( // Добавляем звездный фон
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Этот расклад покажет прошлое, настоящее и будущее.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white, // Белый цвет текста для контраста
                ),
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
                            color: Colors.deepPurple.shade800, // Темный фон для карточек
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                '$imagePath${selectedCards[index]}.jpg',
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade600, // Темный цвет фона для кнопки
                  foregroundColor: Colors.white, // Белый текст на кнопке
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Размер кнопки
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Округлые углы
                  ),
                ),
                child: const Text('Перетасовать карты'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarryBackground extends StatelessWidget {
  final Widget child;

  const StarryBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade900,
            Colors.deepPurple.shade400,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Разбросанные звезды на фоне
          ...List.generate(100, (index) => _buildStar(screenSize)),
          child,
        ],
      ),
    );
  }

  // Функция для создания случайно расположенной звезды
  Widget _buildStar(Size screenSize) {
    final random = Random();
    final double top = random.nextDouble() * screenSize.height;
    final double left = random.nextDouble() * screenSize.width;

    final double size = random.nextDouble() * 3 + 2;

    return Positioned(
      top: top,
      left: left,
      child: Icon(
        Icons.star,
        color: Colors.white.withOpacity(0.8),
        size: size,
      ),
    );
  }
}
