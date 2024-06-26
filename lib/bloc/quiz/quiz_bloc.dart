import 'package:bloc_quiz/bloc/quiz/quiz_event.dart';
import 'package:bloc_quiz/bloc/quiz/quiz_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../utility/prepare_quiz.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  PrepareQuiz prepareQuizHelper;
  int currentCorrectAttempts = 0;
  int currentIndex = 0;
  int currentAttempts = 0;
  int currentWrongAttempts = 0;


  List<int?> selectedOptions = [];
  //List<Color> optionColors = [];

  QuizBloc(this.prepareQuizHelper)
      : super(
      QuizOnGoingState(
          0,
          0,
          0,
          0,
          0,
          prepareQuizHelper.getQuestion(0),
          prepareQuizHelper.getOptions(0),))
          /*List.filled(prepareQuizHelper.getOptions(0).length, const Color(0xffffffff))))*/ {
    /*optionColors = List.filled(prepareQuizHelper.getOptions(0).length, const Color(0xffffffff));*/

    /// Метод для расчета оценки. Учитывает только правильные попытки.
    double _getScore() {
      return currentCorrectAttempts.toDouble(); // 1 балл за правильный ответ
    }

    /// Обработчик события `QuizFinished`.
    on<QuizFinished>((event, emit) async {
      // Проверяем правильность выбранного ответа
      if (event.selectedIndex != -1 && prepareQuizHelper.isCorrect(currentIndex, event.selectedIndex)) {
        currentCorrectAttempts++;
      }

      // Обновляем статистику попыток
      currentAttempts = currentIndex + 1;
      currentWrongAttempts = currentAttempts - currentCorrectAttempts;
      double formulaScore = _getScore();

      // Создаем и отправляем состояние окончания викторины
      QuizState finishedState = QuizFinishedState(
          formulaScore,
          currentIndex,
          currentAttempts,
          currentWrongAttempts,
          currentCorrectAttempts
      );

      emit(finishedState);
    });

    /// Обработчик события `NextQuestion`.
    on<NextQuestion>((event, emit) async {
      // Сохраните выбранный индекс варианта для текущего вопроса
      if (currentIndex < selectedOptions.length) {
        selectedOptions[currentIndex] = event.selectedIndex;
      } else {
        selectedOptions.add(event.selectedIndex);
      }

      // Проверьте правильность выбранного ответа
      if (event.selectedIndex != -1 && prepareQuizHelper.isCorrect(currentIndex, event.selectedIndex)) {
        currentCorrectAttempts++;
      }

      // Обновите статистику попыток
      currentAttempts = currentIndex + 1;
      currentWrongAttempts = currentAttempts - currentCorrectAttempts;
      double formulaScore = _getScore();

      // Переходим к следующему вопросу
      currentIndex++;

      // Создаем и отправляем состояние продолжения викторины
      emit(QuizOnGoingState(
          formulaScore,
          currentIndex,
          currentAttempts,
          currentWrongAttempts,
          currentCorrectAttempts,
          prepareQuizHelper.getQuestion(currentIndex),
          prepareQuizHelper.getOptions(currentIndex),
          //List.filled(prepareQuizHelper.getOptions(currentIndex).length, const Color(0xffffffff))
      ));
    });


    on<PreviousQuestion>((event, emit) async {
      if (currentIndex > 0) {
        // Уменьшите текущий индекс вопроса на единицу
        currentIndex--;

        // Получите сохраненный выбранный индекс для текущего вопроса
        int? savedSelectedIndex = selectedOptions[currentIndex];

        // Обновите текущий вопрос и варианты ответов
        String newQuestion = prepareQuizHelper.getQuestion(currentIndex);
        List<String> newOptions = prepareQuizHelper.getOptions(currentIndex);

        // Создайте список для хранения цветов вариантов ответов
        //List<Color> newOptionColors = List.filled(newOptions.length, const Color(0xffffffff));

        // Если есть сохраненный выбранный вариант, установите его цвет на серый
        //if (savedSelectedIndex != null && savedSelectedIndex >= 0 && savedSelectedIndex < newOptions.length) {
         // newOptionColors[savedSelectedIndex] = const Color(0xffa2f0fa);
       // }

        // Создайте и отправьте новое состояние с обновленным вопросом, вариантами ответов и цветами
        emit(
          QuizOnGoingState(
            currentCorrectAttempts.toDouble(),
            currentIndex,
            currentAttempts,
            currentWrongAttempts,
            currentCorrectAttempts,
            newQuestion,
            newOptions,
           // newOptionColors, // Передайте список цветов вариантов ответов
          ),
        );
      }
    });


  }




}
