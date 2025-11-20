import 'package:cloud_firestore/cloud_firestore.dart';

class CourseEntity {
  final String courseId;
  final String title;
  final String description;
  final String level;
  final Timestamp createdAt;
  final bool hasCollection;
  final int orderIndex;

  CourseEntity({
    required this.courseId,
    required this.title,
    required this.description,
    required this.level,
    required this.createdAt,
    required this.hasCollection,
    required this.orderIndex,
  });
}
