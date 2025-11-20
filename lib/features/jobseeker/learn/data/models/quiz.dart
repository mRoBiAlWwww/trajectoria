import 'package:trajectoria/features/jobseeker/learn/domain/entities/quiz.dart';

class QuizModel {
  final String quizId;
  final String moduleId;
  final String questionText;
  final String option0;
  final String option1;
  final String option2;
  final String option3;
  final int correctAnswer;

  QuizModel({
    required this.quizId,
    required this.moduleId,
    required this.questionText,
    required this.option0,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.correctAnswer,
  });

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      quizId: map['quiz_id'] ?? '',
      moduleId: map['module_id'] ?? '',
      questionText: map['question_text'] ?? '',
      option0: map['option_0'] ?? '',
      option1: map['option_1'] ?? '',
      option2: map['option_2'] ?? '',
      option3: map['option_3'] ?? '',
      correctAnswer: map['correct_answer'],
    );
  }

  Map<String, dynamic> toMap() => {
    'quiz_id': quizId,
    'module_id': moduleId,
    'question_text': questionText,
    'option_0': option0,
    'option_1': option1,
    'option_2': option2,
    'option_3': option3,
    'correct_answer': correctAnswer,
  };

  QuizEntity toEntity() => QuizEntity(
    quizId: quizId,
    moduleId: moduleId,
    questionText: questionText,
    option0: option0,
    option1: option1,
    option2: option2,
    option3: option3,
    correctAnswer: correctAnswer,
  );

  factory QuizModel.fromEntity(QuizEntity entity) => QuizModel(
    quizId: entity.quizId,
    moduleId: entity.moduleId,
    questionText: entity.questionText,
    option0: entity.option0,
    option1: entity.option1,
    option2: entity.option2,
    option3: entity.option3,
    correctAnswer: entity.correctAnswer,
  );
}
