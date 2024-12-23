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
              child: const Text('Перетасовать карты'),
            ),
          ),
        ],
      ),
    );
  }
}
