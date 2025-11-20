import 'package:trajectoria/features/jobseeker/learn/domain/entities/course_chapter.dart';

class CourseChapterModel {
  final String chapterId;
  final String courseId;
  final String title;
  final String description;
  final String duration;
  final int orderIndex;
  final int maximumScore;

  CourseChapterModel({
    required this.chapterId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.maximumScore,
    required this.duration,
  });

  factory CourseChapterModel.fromMap(Map<String, dynamic> map) {
    return CourseChapterModel(
      chapterId: map['chapter_id'] ?? '',
      courseId: map['course_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      orderIndex: map['order_index'] ?? '',
      maximumScore: map['maximum_score'] ?? 0,
      duration: map['duration'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'chapter_id': chapterId,
    'course_id': courseId,
    'title': title,
    'description': description,
    'order_index': orderIndex,
    'maximum_score': maximumScore,
    'duration': duration,
  };

  CourseChapterEntity toEntity() => CourseChapterEntity(
    chapterId: chapterId,
    courseId: courseId,
    title: title,
    description: description,
    orderIndex: orderIndex,
    maximumScore: maximumScore,
    duration: duration,
  );

  factory CourseChapterModel.fromEntity(CourseChapterEntity entity) =>
      CourseChapterModel(
        chapterId: entity.chapterId,
        courseId: entity.courseId,
        title: entity.title,
        description: entity.description,
        orderIndex: entity.orderIndex,
        maximumScore: entity.maximumScore,
        duration: entity.duration,
      );
}
