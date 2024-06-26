import 'package:flutter/material.dart';
import 'package:bloc_quiz/utility/category_detail_list.dart';
import '../../main/prepare_quiz_screen.dart';
import 'category_item.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          margin:
          const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrepareQuizScreen(
                    index: 1,
                    selectedDif: '',
                  )));
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Уменьшение радиуса скругления
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment, size: 30), // Иконка в левой части
                    SizedBox(width: 10), // Отступ между иконкой и текстом
                    Text(
                      'Экзамен',
                      style: TextStyle(fontSize: 24), // Увеличение размера текста
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20), // Расстояние между кнопками

              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrepareQuizScreen(
                    index: 1,
                    selectedDif: '',
                  )));
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Уменьшение радиуса скругления
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.run_circle, size: 30), // Иконка в левой части
                    SizedBox(width: 10), // Отступ между иконкой и текстом
                    Text(
                      'Марафон',
                      style: TextStyle(fontSize: 24), // Увеличение размера текста
                    ),
                  ],
                ),
              ),

              /*const SizedBox(height: 5),
              ListView.builder(
                itemCount: 1 /*categoryDetailList.length*/,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CategoryItem(0  /*index*/);
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
