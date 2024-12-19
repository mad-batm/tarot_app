import 'package:flutter/material.dart';
import 'dart:math';

class SpreadDailyAdvice extends StatefulWidget {
  const SpreadDailyAdvice({super.key});

  @override
  _SpreadDailyAdviceState createState() => _SpreadDailyAdviceState();
}

class _SpreadDailyAdviceState extends State<SpreadDailyAdvice> {
  final List<String> deck = [
    'shut',
    'mag',
    'zhrica',
    'impress',
    'imperor',
    'hierofant',
    'lovers',
    'chariot',
    'strength',
    'hermit',
    'fortune',
    'justise',
    'hanged',
    'death',
    'temperam',
    'devil',
    'tower',
    'stare',
    'moon',
    'sun',
    'sud',
    'world',
  ];

  String? selectedCard;
  bool _isLoading = true;
  bool _isCardVisible = false;
  Alignment _cardAlignment = Alignment.bottomCenter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    for (String card in deck) {
      await precacheImage(
        AssetImage('assets/images/$card.jpg'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Совет дня'),
      ),
      body: _isLoading
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
                                'assets/images/$selectedCard.jpg',
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
                      child: const Text('Вытянуть новую карту'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
