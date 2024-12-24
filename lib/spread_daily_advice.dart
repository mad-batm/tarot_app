import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'change_notifier.dart';

class SpreadDailyAdvice extends StatefulWidget {
  const SpreadDailyAdvice({super.key});

  @override
  _SpreadDailyAdviceState createState() => _SpreadDailyAdviceState();
}

class _SpreadDailyAdviceState extends State<SpreadDailyAdvice> {
  late List<String> deck;
  late String imagePath;

  String? selectedCard;
  bool _isLoading = true;
  bool _isCardVisible = false;
  Alignment _cardAlignment = Alignment.bottomCenter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Получаем данные из провайдера один раз
    final deckProvider = Provider.of<DeckProvider>(context, listen: false);
    deck = deckProvider.currentDeck;
    imagePath = deckProvider.currentDeckImagePath;

    // Загружаем изображения
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    for (String cardName in deck) {
      await precacheImage(
        AssetImage('$imagePath$cardName.jpg'),
        context,
      );
    }

    setState(() {
      _isLoading = false;
      _drawDailyAdvice();
    });
  }

  void _drawDailyAdvice() {
    final random = Random();
    setState(() {
      selectedCard = deck[random.nextInt(deck.length)];
      _animateCard();
    });
  }

  void _animateCard() {
    setState(() {
      _isCardVisible = false;
      _cardAlignment = Alignment.bottomCenter;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isCardVisible = true;
        _cardAlignment = Alignment.center;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deckProvider = Provider.of<DeckProvider>(context); // Получаем текущую колоду с listen: true для перерисовки UI

    return Scaffold(
      appBar: AppBar(
        title: const Text('Совет дня'),
      ),
      body: StarryBackground( // Добавляем звездное небо
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            // Текст вверху экрана
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Твоя карта дня — это совет, который поможет понять текущую ситуацию.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white, // Белый цвет текста для контраста
                  ),
                ),
              ),
            ),
            // Анимация карты
            AnimatedAlign(
              duration: const Duration(seconds: 1),
              alignment: _cardAlignment,
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _isCardVisible ? 1.0 : 0.0,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: selectedCard != null
                        ? Image.asset(
                      '$imagePath${selectedCard!}.jpg', // Используем выбранную карту
                      width: 150,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            // Кнопка внизу
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: ElevatedButton(
                  onPressed: _drawDailyAdvice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade600, // Темный цвет фона для кнопки
                    foregroundColor: Colors.white, // Белый текст на кнопке
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Размер кнопки
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Округлые углы
                    ),
                  ),
                  child: const Text('Вытянуть новую карту'),
                ),
              ),
            ),
          ],
        ),
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
