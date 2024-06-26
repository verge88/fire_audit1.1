import 'package:bloc_quiz/data/repositories/result_repo.dart';
import 'package:flutter/material.dart';
import 'package:fl_score_bar/fl_score_bar.dart';
import 'package:bloc_quiz/utility/category_detail_list.dart';

class ResultDetailScreen extends StatelessWidget {
  final double score;
  final int categoryIndex;
  final String difficultyLevel;
  final int attempts;
  final int wrongAttempts;
  final int correctAttempts;
  final bool isSaved;

  // Устанавливаем максимальный балл
  static const double maxScore = 40.0;

  final ResultRepo resultRepo = ResultRepo();

  ResultDetailScreen(
      {Key? key,
        required this.score,
        required this.categoryIndex,
        required this.attempts,
        required this.wrongAttempts,
        required this.correctAttempts,
        required this.difficultyLevel,
        required this.isSaved})
      : super(key: key) {
    // Проверяем, что балл не превышает максимальный балл
    final finalScore = score <= maxScore ? score : maxScore;

    // Если результат еще не сохранен, сохраняем его
    if (!isSaved) {
      resultRepo.saveScore(
          finalScore,
          difficultyLevel,
          attempts,
          wrongAttempts,
          correctAttempts,
          categoryDetailList[categoryIndex].title,
          categoryIndex
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: categoryDetailList[categoryIndex].textColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${categoryDetailList[categoryIndex].title}: ${difficultyLevel.toString()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            IconScoreBar(
              scoreIcon: Icons.star_rounded,
              iconColor: Colors.yellow,
              score: (score / 2).clamp(0.0, 7.0), // Убедитесь, что score не превышает maxScore (7)
              maxScore: 7,
              readOnly: true,
            ),

            const SizedBox(height: 30),
            Text(
              'Баллов набрано $score', // Здесь мы также используем finalScore
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Ответов: ${attempts.toString()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Неправильных ответов: ${wrongAttempts.toString()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Правильных ответов: ${correctAttempts.toString()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 0.3 * MediaQuery.of(context).size.width,
                height: 0.08 * MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1, 3),
                      blurRadius: 0.7,
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check,
                  color: const Color(0xff000000),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
