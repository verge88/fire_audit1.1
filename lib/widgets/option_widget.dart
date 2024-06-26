import 'package:flutter/material.dart';

import '../presentation/main/question_screen.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    Key? key,
    required this.widget,
    required this.option,
    required this.onTap,
    required this.optionColor,
  }) : super(key: key);

  final QuestionsScreen widget;
  final String option;
  final VoidCallback onTap;
  final Color optionColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        alignment: Alignment.centerLeft,
        width: double.infinity, // Занимает всю ширину экрана
        decoration: BoxDecoration(
          color: optionColor,
          borderRadius: BorderRadius.circular(15),
          // Добавление тени
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Цвет тени и ее непрозрачность
              blurRadius: 3, // Размер размытости тени
              offset: const Offset(1, 1), // Смещение тени по оси X и Y
            ),
          ],
        ),
        child: Text(
          option,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
