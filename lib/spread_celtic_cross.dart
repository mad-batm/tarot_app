import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'change_notifier.dart';

class SpreadCelticCross extends StatefulWidget {
  const SpreadCelticCross({super.key});

  @override
  _SpreadCelticCrossState createState() => _SpreadCelticCrossState();
}

class _SpreadCelticCrossState extends State<SpreadCelticCross> {
  List<String> selectedCards = [];
  List<bool> cardVisible = List.generate(10, (_) => false);

  @override
  void initState() {
    super.initState();
    _generateCelticCross();
  }

  void _generateCelticCross() async {
    // Получаем текущую колоду из провайдера с listen: true
    final deckProvider = Provider.of<DeckProvider>(context, listen: false);
    final deck = deckProvider.currentDeck;

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
      body: StarryBackground( // Добавляем звездное небо
        child: Container(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Кельтский крест — это детальный анализ ситуации с 10 картами.',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white, // Белый цвет текста для контраста
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    // Центральные карты с анимацией
                    _buildAnimatedCard(150, 120, selectedCards[0], cardVisible[0]),
                    _buildAnimatedCard(150, 120, selectedCards[1], cardVisible[1], rotation: pi / 2),
                    // Карты вокруг центра
                    _buildAnimatedCard(30, 120, selectedCards[2], cardVisible[2]), // Над центром
                    _buildAnimatedCard(270, 120, selectedCards[3], cardVisible[3]), // Под центром
                    _buildAnimatedCard(150, 20, selectedCards[4], cardVisible[4]), // Слева
                    _buildAnimatedCard(150, 220, selectedCards[5], cardVisible[5]), // Справа
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
          tween: Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0)),
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
    // Получаем путь к изображениям из провайдера
    final deckProvider = Provider.of<DeckProvider>(context);
    final imagePath = deckProvider.currentDeckImagePath;

    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.black26)],
      ),
      child: Image.asset(
        '$imagePath$cardName.jpg', // Формируем путь к изображению с учетом текущей колоды
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}

// Звездное небо
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
