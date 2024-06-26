import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class NextQuestion extends QuizEvent {
  final int selectedIndex;
  NextQuestion(this.selectedIndex);
}

class PreviousQuestion extends QuizEvent {
  final int selectedIndex;
  PreviousQuestion(this.selectedIndex);
}

class QuizFinished extends QuizEvent {
  final int selectedIndex;
  QuizFinished(this.selectedIndex);
}