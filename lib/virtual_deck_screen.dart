import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'change_notifier.dart';

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
      body: Padding(
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
                  )

                  /*Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      deck[index].replaceAll('_', ' ').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),*/
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
