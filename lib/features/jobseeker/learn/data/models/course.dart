import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course.dart';

class CourseModel {
  final String courseId;
  final String title;
  final String description;
  final String level;
  final Timestamp createdAt;
  final bool hasCollection;
  final int orderIndex;

  CourseModel({
    required this.courseId,
    required this.title,
    required this.description,
    required this.level,
    required this.createdAt,
    required this.hasCollection,
    required this.orderIndex,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      courseId: map['course_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      level: map['level'] ?? '',
      createdAt: map['created_at'] is Timestamp
          ? map['created_at'] as Timestamp
          : Timestamp.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
      // createdAt: map['created_at'] as Timestamp,
      hasCollection: map['has_collection'] ?? false,
      orderIndex: map['order_index'],
    );
  }

  Map<String, dynamic> toMap() => {
    'course_id': courseId,
    'title': title,
    'description': description,
    'level': level,
    'created_at': createdAt.millisecondsSinceEpoch,
    // 'created_at': createdAt,
    'has_collection': hasCollection,
    'order_index': orderIndex,
  };

  CourseEntity toEntity() => CourseEntity(
    courseId: courseId,
    title: title,
    description: description,
    level: level,
    createdAt: createdAt,
    hasCollection: hasCollection,
    orderIndex: orderIndex,
  );

  factory CourseModel.fromEntity(CourseEntity entity) => CourseModel(
    courseId: entity.courseId,
    title: entity.title,
    description: entity.description,
    level: entity.level,
    createdAt: entity.createdAt,
    hasCollection: entity.hasCollection,
    orderIndex: entity.orderIndex,
  );
}
