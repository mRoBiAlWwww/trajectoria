class ModuleEntity {
  final String moduleId;
  final String subchapterId;
  final String courseId;
  final String title;
  final int orderIndex;
  final String content;
  final int maximumScore;
  final String chapterId;

  ModuleEntity({
    required this.moduleId,
    required this.subchapterId,
    required this.courseId,
    required this.title,
    required this.orderIndex,
    required this.content,
    required this.maximumScore,
    required this.chapterId,
  });
}
