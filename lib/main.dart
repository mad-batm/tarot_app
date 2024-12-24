import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'spread_selection_screen.dart';
import 'virtual_deck_screen.dart';
import 'change_notifier.dart';
import 'dart:math';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DeckProvider(),
      child: TarotApp(),
    ),
  );
}

class TarotApp extends StatelessWidget {
  const TarotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarot App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
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
            for (int i = 0; i < 100; i++) _buildStar(screenSize),

            // Луна, увеличенная, повернутая и прижата к левому краю
            Positioned(
              top: 50, // Располагаем немного ниже верхнего края
              left: 20, // Прижимаем к левому краю экрана
              child: Transform.rotate(
                angle: -pi / 6, // Поворот на -30 градусов
                child: Icon(
                  Icons.nightlight_round, // Иконка луны
                  color: Colors.white, // Белый цвет
                  size: 80, // Увеличенный размер иконки
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Кнопка "Выбрать расклад" с градиентом и границей
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpreadSelectionPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.deepPurple.shade600,
                            Colors.blueAccent.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.deepPurple.shade800, // Явно видимая темная граница
                          width: 3, // Толщина границы
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      child: const Text(
                        'Выбрать расклад',
                        style: TextStyle(
                          fontSize: 22, // Увеличенный шрифт
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50), // Увеличиваем расстояние между кнопками
                  // Кнопка "Открыть виртуальную колоду" с градиентом и границей
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VirtualDeckScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.deepPurple.shade600,
                            Colors.blueAccent.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.deepPurple.shade800, // Явно видимая темная граница
                          width: 3, // Толщина границы
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      child: const Text(
                        'Открыть виртуальную колоду',
                        style: TextStyle(
                          fontSize: 22, // Увеличенный шрифт
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Функция для создания случайно расположенной звезды
  Widget _buildStar(Size screenSize) {
    final random = Random();
    // Случайные координаты на экране
    final double top = random.nextDouble() * screenSize.height;
    final double left = random.nextDouble() * screenSize.width;

    // Случайный размер
    final double size = random.nextDouble() * 3 + 2;

    return Positioned(
      top: top, // Пропорциональное положение по высоте
      left: left, // Пропорциональное положение по ширине
      child: Icon(
        Icons.star,
        color: Colors.white.withOpacity(0.8),
        size: size, // Размер звезды
      ),
    );
  }
}
