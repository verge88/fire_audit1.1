// lib/presentation/questions/questions_screen.dart
import 'package:flutter/material.dart';
import '../../data/model/questions.dart';

import '../../data/repositories/quiz_repo.dart';


class QuestionsScreen extends StatefulWidget {
  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late Future<List<Question>> futureQuestions;
  final String url = 'https://firebasestorage.googleapis.com/v0/b/quiz-4c367.appspot.com/o/pb.json?alt=media&token=3449d7d7-260a-452a-b597-90315604b019';

  @override
  void initState() {
    super.initState();
    futureQuestions = fetchQuestions();
  }

  Future<List<Question>> fetchQuestions() async {
    QuizDataRepository repository = QuizDataRepository(url);
    List<dynamic> data = await repository.getData();
    return data.map((json) => Question.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Вопросы')),
      body: FutureBuilder<List<Question>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available.'));
          }

          List<Question> questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(questions[index].question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ...questions[index].options.map((option) => RadioListTile(
                        title: Text(option),
                        value: questions[index].options.indexOf(option),
                        groupValue: questions[index].correctAnswer,
                        onChanged: (value) {},
                      )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
