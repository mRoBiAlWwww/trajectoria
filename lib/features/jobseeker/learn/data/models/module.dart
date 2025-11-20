import 'package:trajectoria/features/jobseeker/learn/domain/entities/module.dart';

class ModuleModel {
  final String moduleId;
  final String subchapterId;
  final String courseId;
  final String title;
  final int orderIndex;
  final String content;
  final int maximumScore;
  final String chapterId;

  ModuleModel({
    required this.moduleId,
    required this.subchapterId,
    required this.courseId,
    required this.title,
    required this.orderIndex,
    required this.content,
    required this.maximumScore,
    required this.chapterId,
  });

  factory ModuleModel.fromMap(Map<String, dynamic> map) {
    return ModuleModel(
      moduleId: map['module_id'] ?? '',
      subchapterId: map['subchapter_id'] ?? '',
      courseId: map['course_id'] ?? '',
      title: map['title'] ?? '',
      orderIndex: map['order_index'] ?? 0,
      content: map['content'] ?? '',
      maximumScore: map['maximum_score'],
      chapterId: map['chapter_id'],
    );
  }

  Map<String, dynamic> toMap() => {
    'module_id': moduleId,
    'subchapter_id': subchapterId,
    'course_id': courseId,
    'title': title,
    'order_index': orderIndex,
    'content': content,
    'maximum_score': maximumScore,
    'chapter_id': chapterId,
  };

  ModuleEntity toEntity() => ModuleEntity(
    moduleId: moduleId,
    subchapterId: subchapterId,
    courseId: courseId,
    title: title,
    orderIndex: orderIndex,
    content: content,
    maximumScore: maximumScore,
    chapterId: chapterId,
  );

  factory ModuleModel.fromEntity(ModuleEntity entity) => ModuleModel(
    moduleId: entity.moduleId,
    subchapterId: entity.subchapterId,
    courseId: entity.courseId,
    title: entity.title,
    orderIndex: entity.orderIndex,
    content: entity.content,
    maximumScore: entity.maximumScore,
    chapterId: entity.chapterId,
  );
}
