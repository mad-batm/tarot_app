import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Deck {
  final String name;
  final List<String> cards;
  final String imagePath;

  Deck({
    required this.name,
    required this.cards,
    required this.imagePath,
  });
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
        'pents01', 'pents02', 'pents03', 'pents04',
        'pents05', 'pents06', 'pents07', 'pents08',
        'pents09', 'pents10', 'pents11', 'pents12',
        'pents13', 'pents14',
      ],
      imagePath: 'assets/images/classic/',
    ),
    Deck(
      name: 'Мистическая колода',
      cards: [
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
        'pents01', 'pents02', 'pents03', 'pents04',
        'pents05', 'pents06', 'pents07', 'pents08',
        'pents09', 'pents10', 'pents11', 'pents12',
        'pents13', 'pents14',
      ],
      imagePath: 'assets/images/durer/',
    ),
  ];

  // Индекс текущей выбранной колоды
  int _currentDeckIndex = 0;

  // Состояние для выбранной карты
  String? _selectedCard;
  String? _selectedCardInfo;
  String? _selectedCardMeaningUp;
  String? _selectedCardMeaningRev;
  bool _isLoading = false;

  // Локальные описания карт
  Map<String, Map<String, String>> _cardDetails =
      {}; // Каждая карта хранит подробную информацию

  // Геттеры
  List<String> get currentDeck => _decks[_currentDeckIndex].cards;
  String get currentDeckImagePath => _decks[_currentDeckIndex].imagePath;
  String? get selectedCard => _selectedCard;
  String? get selectedCardInfo => _selectedCardInfo;
  String? get selectedCardMeaningUp => _selectedCardMeaningUp;
  String? get selectedCardMeaningRev => _selectedCardMeaningRev;
  bool get isLoading => _isLoading;

  // Метод для изменения колоды
  void changeDeck(int index) {
    _currentDeckIndex = index;
    notifyListeners();
  }

  // Метод для загрузки данных карт из JSON
  Future<void> loadCardDescriptions() async {
    try {
      _isLoading = true;
      notifyListeners();
      final String jsonString =
          await rootBundle.loadString('assets/card_data.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      // Преобразуем массив карт в Map с подробной информацией
      Map<String, Map<String, String>> details = {};
      for (var card in data['cards']) {
        final String cardName = card['name_short'];
        final String description = card['desc'];
        final String meaningUp = card['meaning_up'];
        final String meaningRev = card['meaning_rev'];
        // Заполняем Map для каждой карты
        details[cardName] = {
          'name': cardName,
          'description': description,
          'meaning_up': meaningUp,
          'meaning_rev': meaningRev,
          // Добавьте любые другие данные, если они есть
        };
      }

      _cardDetails = details;
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка загрузки описаний карт: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Получить полную информацию о карте
  Map<String, String>? getCardInfo(String cardName) {
    return _cardDetails[cardName];
  }

  // Выбрать карту и получить её полную информацию
  void selectCard(String cardName) {
    if (_cardDetails.containsKey(cardName)) {
      _selectedCard = cardName;
      _selectedCardInfo = getCardInfo(cardName)?['description'];
      _selectedCardMeaningUp = getCardInfo(cardName)?['meaning_up'];
      _selectedCardMeaningRev = getCardInfo(
          cardName)?['meaning_rev']; // сохраняем значение 'meaning_up'
    } else {
      _selectedCard = null;
      _selectedCardInfo = null;
      _selectedCardMeaningUp = null;
      _selectedCardMeaningRev = null;
    }
    notifyListeners();
  }
}
