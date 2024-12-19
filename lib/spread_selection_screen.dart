import 'package:flutter/material.dart';
//import 'package:tarot_app/spread_daily_advice.dart';
//import 'package:tarot_app/spread_detail_screen.dart';
//import 'package:tarot_app/spread_love_path.dart';
import 'spread_three_cards.dart';
import 'spread_celtic_cross.dart';
import 'spread_pyramid.dart';
import 'spread_love_path.dart';
import 'spread_daily_advice.dart';

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
      ),
      body: ListView.builder(
        itemCount: spreads.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(spreads[index]['icon'], color: Colors.purple),
              title: Text(spreads[index]['title']),
              subtitle: Text(spreads[index]['description']),
              trailing: ElevatedButton(
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
    );
  }
}
