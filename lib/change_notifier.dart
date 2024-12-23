import 'package:flutter/material.dart';

class Deck {
  final String name;
  final List<String> cards;
  final String imagePath;

  Deck({required this.name, required this.cards, required this.imagePath});
}

class DeckProvider with ChangeNotifier {
  // Перечень доступных колод
  final List<Deck> _decks = [
    Deck(
      name: 'Классическая колода',
      cards: [
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
      ],
      imagePath: 'assets/images/classic/',
    ),
    Deck(
      name: 'Мистическая колода',
      cards: [
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
      ],
      imagePath: 'assets/images/durer/',
    ),
  ];

  // Индекс текущей выбранной колоды
  int _currentDeckIndex = 0;

  // Геттеры
  List<String> get currentDeck => _decks[_currentDeckIndex].cards;
  String get currentDeckImagePath => _decks[_currentDeckIndex].imagePath;

  // Метод для изменения колоды
  void changeDeck(int index) {
    _currentDeckIndex = index;
    notifyListeners(); // Уведомляем подписчиков, что состояние изменилось
  }
}
