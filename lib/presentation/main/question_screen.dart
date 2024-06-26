import 'package:bloc_quiz/bloc/quiz/quiz_state.dart';
import 'package:bloc_quiz/presentation/main/result_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:bloc_quiz/utility/prepare_quiz.dart';
import 'package:bloc_quiz/utility/category_detail_list.dart';
import 'package:bloc_quiz/widgets/close_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz/quiz_bloc.dart';
import '../../bloc/quiz/quiz_event.dart';
import '../../widgets/option_widget.dart';

class QuestionsScreen extends StatefulWidget {
  QuestionsScreen({
    Key? key,
    required this.questionData,
    required this.categoryIndex,
    required this.difficultyLevel,
  }) : super(key: key);

  final questionData;
  final int categoryIndex;
  final String difficultyLevel;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  void initState() {
    super.initState();
    quizMaker.populateList(widget.questionData);
  }

  PrepareQuiz quizMaker = PrepareQuiz();
  int questionNumber = 0;

  bool isAbsorbing = false;

  final int duration = 10;

  List<Color> optionColor = [
    const Color(0xffffffff),
    const Color(0xffffffff),
    const Color(0xffffffff),
    const Color(0xffffffff)
  ];

  int selectedOption = -1; // Установим начальное значение selectedOption на -1

  List<Widget> buildOptions(List<String> options) {
    List<Widget> optionWidgets = [];

    for (int j = 0; j < options.length; j++) {
      optionWidgets.add(OptionWidget(
        widget: widget,
        option: options[j],
        optionColor: optionColor[j],
        onTap: () {
          setState(() {
            // Сбросить цвет выбранного ранее варианта на белый
            if (selectedOption != -1) {
              optionColor[selectedOption] = Colors.white;
            }
            // Установить цвет выбранного варианта на зеленый
            selectedOption = j;
            optionColor[selectedOption] = const Color(0xffcdf7ff);
          });
        },
      ));
    }

    return optionWidgets;
  }

  Widget buildQuestionText(QuizOnGoingState state) {
    return Card(
      //elevation: 0, // Устанавливаем тень в 0, чтобы убрать ее полностью
      color: Colors.white, // Цвет карточки из темы
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Скругляем углы
      ),
      child: SizedBox(
        width: double.infinity, // Карточка занимает всю ширину экрана
        //height: 250, // Фиксированная высота карточки
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(state.currentIndex + 1)} из ${state.totalQuestions}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  state.currentQuestion,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildOptionSection(QuizOnGoingState state) {
    return Card(
      elevation: 0, // Устанавливаем тень в 0, чтобы убрать ее полностью
      color: Colors.white, // Цвет карточки из темы
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Скругляем углы
      ),
      child: SizedBox(
        width: double.infinity, // Карточка занимает всю ширину экрана
        height: 300, // Фиксированная высота карточки
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: SingleChildScrollView(
            child: Column(
              children: buildOptions(state.options),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(quizMaker),
      child: BlocListener<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizFinishedState) {
            _navigateToResultScreen(context, state);
          }
        },
        child: BlocBuilder<QuizBloc, QuizState>(
          buildWhen: (previous, current) => true,
          builder: (BuildContext context, state) {
            if (state is QuizOnGoingState) {
              return AbsorbPointer(
                absorbing: isAbsorbing,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 60, bottom: 20),
                  decoration: BoxDecoration(
                    color: categoryDetailList[widget.categoryIndex].textColor,
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Верхняя строка с кнопкой закрытия
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            RoundCloseButton(),
                          ],
                        ),
                        // Блок с текстом вопроса
                        buildQuestionText(state),
                        // Блок с кнопками вариантов ответа
                        Expanded(
                          child: buildOptionSection(state),
                        ),
                        // Расстояние между карточкой с вариантами ответов и кнопкой "Далее"
                        const SizedBox(height: 20),
                        // Строка с кнопками "назад" и "далее"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _navigateToResultScreen(context, state),
                              child: const Text('Закончить попытку'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                minimumSize: const Size(100, 50),//////// HERE
                              ),
                            ),
                            const SizedBox(width: 45), // Разделитель между кнопками
                            // Кнопка "назад"
                            /*ElevatedButton(
                              onPressed: () {
                                // Событие для перехода к предыдущему вопросу
                                if (state.currentIndex > 0) {
                                  // Сбросить цвет выбранного варианта на белый
                                  if (selectedOption != -1) {
                                    optionColor[selectedOption] = Colors.white;
                                  }
                                  BlocProvider.of<QuizBloc>(context)
                                      .add(PreviousQuestion(selectedOption));
                                }
                              },
                              child: const Text('Назад'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                minimumSize: const Size(100, 50),
                              ),
                            ),*/
                            const SizedBox(width: 10), // Разделитель между кнопками
                            // Кнопка "далее"
                            ElevatedButton(
                              onPressed: () {
                                // Проверка, чтобы не выйти за пределы количества вопросов
                                if (state.currentIndex <
                                    state.totalQuestions - 1) {
                                  // Сбросить цвет выбранного варианта на белый
                                  if (selectedOption != -1) {
                                    optionColor[selectedOption] = Colors.white;
                                  }
                                  // Передать индекс выбранного варианта
                                  int selectedIndex = selectedOption;
                                  selectedOption = -1; // Сбросить выбранный вариант
                                  BlocProvider.of<QuizBloc>(context)
                                      .add(NextQuestion(selectedIndex));
                                } else {
                                  BlocProvider.of<QuizBloc>(context)
                                      .add(QuizFinished(selectedOption));
                                }
                              },
                              child: const Text('Далее'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                minimumSize: const Size(100, 50),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Text('Loading...');
          },
        ),
      ),
    );
  }
  void _navigateToResultScreen(context, QuizState state) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultDetailScreen(
          score: state.currentScore,
          categoryIndex: widget.categoryIndex,
          attempts: state.currentAttempts,
          wrongAttempts: state.currentWrongAttempts,
          correctAttempts: state.currentCorrectAttempts,
          difficultyLevel: widget.difficultyLevel,
          isSaved: false,
        ),
      ),
    );
  }
}
