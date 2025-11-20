class QuizEntity {
  final String quizId;
  final String moduleId;
  final String questionText;
  final String option0;
  final String option1;
  final String option2;
  final String option3;
  final int correctAnswer;

  QuizEntity({
    required this.quizId,
    required this.moduleId,
    required this.questionText,
    required this.option0,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.correctAnswer,
  });
}
