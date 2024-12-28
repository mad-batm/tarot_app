import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'change_notifier.dart';

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
          ...List.generate(100, (index) => _buildStar(screenSize)),
          child,
        ],
      ),
    );
  }

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

class CardDetailPage extends StatelessWidget {
  final String cardName;
  final String imagePath;

  const CardDetailPage({
    super.key,
    required this.cardName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final deckProvider = Provider.of<DeckProvider>(context);
    final cardInfo = deckProvider.getCardInfo(cardName);

    if (cardInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(cardName.replaceAll('_', ' ')),
        ),
        body: const StarryBackground(
          child: Center(
            child: Text(
              'Информация о карте не найдена.',
              style: TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(cardInfo['name']?.replaceAll('_', ' ') ?? 'Карта'),
      ),
      body: StarryBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Изображение карты
                Center(
                  child: Image.asset(
                    imagePath,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 100);
                    },
                    height: 250,
                    width: 250,
                  ),
                ),
                const SizedBox(height: 20),

                // Название карты
                Text(
                  cardInfo['name']?.replaceAll('_', ' ') ?? 'Без названия',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Прямое положение карты
                RichText(
                  text: TextSpan(
                    text: 'Прямое положение: ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: cardInfo['meaning_up'] ?? 'Не указано',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Обратное положение карты
                RichText(
                  text: TextSpan(
                    text: 'Перевёрнутое положение: ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: cardInfo['meaning_rev'] ?? 'Не указано',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Полное описание карты
                RichText(
                  text: TextSpan(
                    text: 'Совет дня: ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: cardInfo['description'] ?? 'Не указано',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
