import 'package:trajectoria/features/jobseeker/learn/domain/entities/quiz.dart';

abstract class QuizState {
  const QuizState();
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizzesLoaded extends QuizState {
  final List<QuizEntity> quizzes;
  QuizzesLoaded(this.quizzes);
}

class SuccessfulProcess extends QuizState {
  final String message;
  SuccessfulProcess(this.message);
}

class QuizFailure extends QuizState {}
