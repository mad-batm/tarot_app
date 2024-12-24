import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'change_notifier.dart';

class SpreadLovePath extends StatefulWidget {
  const SpreadLovePath({super.key});

  @override
  _SpreadLovePathState createState() => _SpreadLovePathState();
}

class _SpreadLovePathState extends State<SpreadLovePath>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> selectedCards;
  late String imagePath;
  late List<String> deck;

  final List<Offset> cardPositions = [
    Offset(-0.7, -0.5),
    Offset(-0.4, 0),
    Offset(0.0, 0.5),
    Offset(0.4, 0),
    Offset(0.7, -0.5),
    Offset(0.0, -0.8),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Получаем колоду и путь к изображениям через провайдер
    final deckProvider = Provider.of<DeckProvider>(context);

    // Обновляем deck и imagePath из провайдера, чтобы UI реагировал на изменения
    deck = deckProvider.currentDeck;
    imagePath = deckProvider.currentDeckImagePath;

    // Перетасовать колоду при изменении данных
    _shuffleDeck();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
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
      body: StarryBackground( // Добавляем звездное небо
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Этот расклад анализирует отношения и их развитие.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white, // Белый цвет текста для контраста
                ),
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

  Widget _buildAnimatedCard(String card, int index) {
    final animationPosition =
    Tween<Offset>(begin: Offset(0, 2), end: cardPositions[index])
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(index * 0.1, min(1.0, index * 0.1 + 0.5),
          curve: Curves.easeOut),
    ));

    final animationOpacity =
    Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(index * 0.1, min(1.0, index * 0.1 + 0.3),
          curve: Curves.easeIn),
    ));

    final animationRotation =
    Tween<double>(begin: pi / 6, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(index * 0.1, min(1.0, index * 0.1 + 0.5),
          curve: Curves.easeOut),
    ));

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
          '$imagePath$card.jpg', // Используем путь из провайдера
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
