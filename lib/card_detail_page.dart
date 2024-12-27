import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'change_notifier.dart';

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
    // Получаем информацию о карте из DeckProvider
    final deckProvider = Provider.of<DeckProvider>(context);
    final cardInfo = deckProvider.getCardInfo(cardName);

    if (cardInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(cardName.replaceAll('_', ' ')),
        ),
        body: Center(
          child: Text(
            'Информация о карте не найдена.',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(cardInfo['name']?.replaceAll('_', ' ') ?? 'Карта'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Изображение карты
              Image.asset(
                imagePath,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 100);
                },
                height: 250,
                width: 250,
              ),
              const SizedBox(height: 20),

              // Название карты
              Text(
                cardInfo['name']?.replaceAll('_', ' ') ?? 'Без названия',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Прямое положение карты
              Text(
                'Прямое положение: ${cardInfo['meaning_up'] ?? 'Не указано'}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Обратное положение карты
              Text(
                'Обратное положение: ${cardInfo['meaning_rev'] ?? 'Не указано'}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Полное описание карты
              Text(
                'Полное описание: ${cardInfo['description'] ?? 'Не указано'}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
