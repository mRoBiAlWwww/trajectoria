class CourseChapterEntity {
  final String chapterId;
  final String courseId;
  final String title;
  final String description;
  final String duration;
  final int orderIndex;
  final int maximumScore;

  CourseChapterEntity({
    required this.chapterId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.maximumScore,
    required this.duration,
  });
}
