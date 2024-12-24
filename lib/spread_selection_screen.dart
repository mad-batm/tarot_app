import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'spread_three_cards.dart';
import 'spread_celtic_cross.dart';
import 'spread_pyramid.dart';
import 'spread_love_path.dart';
import 'spread_daily_advice.dart';
import 'dart:math';

class SpreadSelectionPage extends StatelessWidget {
  // Список раскладов с их описаниями и иконками
  final List<Map<String, dynamic>> spreads = const [
    {
      "title": "Три карты",
      "description": "Простой расклад на прошлое, настоящее и будущее.",
      "icon": Icons.layers
    },
    {
      "title": "Кельтский крест",
      "description": "Расклад для глубокого анализа ситуации.",
      "icon": Icons.account_tree
    },
    {
      "title": "Пирамида",
      "description": "Расклад на пути к цели.",
      "icon": Icons.change_history
    },
    {
      "title": "Путь любви",
      "description": "Расклад на отношения и чувства.",
      "icon": Icons.favorite
    },
    {
      "title": "Совет дня",
      "description": "Один совет на текущий день.",
      "icon": Icons.wb_sunny
    },
  ];

  const SpreadSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор расклада'),
        backgroundColor: Colors.deepPurple.shade700, // Темный фон для AppBar
      ),
      body: StarryBackground(
        child: ListView.builder(
          itemCount: spreads.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.deepPurple.shade800, // Однотонный темный фон для карточки
              margin: const EdgeInsets.all(8.0),
              elevation: 3,
              child: ListTile(
                leading: Icon(
                  spreads[index]['icon'],
                  color: Colors.white, // Белый цвет иконки
                ),
                title: Text(
                  spreads[index]['title'],
                  style: const TextStyle(
                    color: Colors.white, // Белый текст
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  spreads[index]['description'],
                  style: const TextStyle(
                    color: Colors.white, // Белый текст
                  ),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade600, // Темный цвет фона для кнопки
                    foregroundColor: Colors.white, // Белый текст на кнопке
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Размер кнопки
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Округлые углы
                    ),
                  ),
                  onPressed: () {
                    if (spreads[index]['title'] == 'Три карты') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpreadThreeCards()),
                      );
                    }
                    if (spreads[index]['title'] == 'Кельтский крест') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpreadCelticCross()),
                      );
                    }
                    if (spreads[index]['title'] == 'Пирамида') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpreadPyramid()),
                      );
                    }
                    if (spreads[index]['title'] == 'Путь любви') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpreadLovePath()),
                      );
                    }
                    if (spreads[index]['title'] == 'Совет дня') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpreadDailyAdvice()),
                      );
                    }
                    // В дальнейшем добавим логику для других раскладов
                  },
                  child: const Text('Сделать расклад'),
                ),
              ),
            );
          },
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
