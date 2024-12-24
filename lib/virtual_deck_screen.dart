import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'change_notifier.dart';
import 'dart:math';

class VirtualDeckScreen extends StatelessWidget {
  const VirtualDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем текущую колоду и путь к изображениям из DeckProvider
    final deckProvider = Provider.of<DeckProvider>(context);
    final deck = deckProvider.currentDeck;
    final imagePath = deckProvider.currentDeckImagePath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Виртуальная колода'),
        actions: [
          // Кнопка для выбора колоды
          PopupMenuButton<int>(
            icon: const Icon(Icons.collections),
            onSelected: (index) {
              deckProvider.changeDeck(index); // Смена колоды по индексу
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text('Классическая колода'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Мистическая колода'),
                ),
              ];
            },
          ),
        ],
      ),
      body: StarryBackground(
        child: Padding(
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
                color: Colors.deepPurple.shade800, // Однотонный темный фон для карточки
                elevation: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        '$imagePath${deck[index]}.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                    // Отображение текста на карточке с белым шрифтом
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        deck[index].replaceAll('_', ' ').toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white, // Белый цвет для текста
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
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
