import 'package:trajectoria/features/jobseeker/learn/domain/entities/subchapter.dart';

class SubChapterModel {
  final String subchapterId;
  final String chapterId;
  final String title;
  final String description;
  final bool hasCollection;
  final int orderIndex;

  SubChapterModel({
    required this.subchapterId,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.hasCollection,
    required this.orderIndex,
  });

  factory SubChapterModel.fromMap(Map<String, dynamic> map) {
    return SubChapterModel(
      subchapterId: map['subchapter_id'] ?? '',
      chapterId: map['chapter_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      hasCollection: map['has_collection'] ?? false,
      orderIndex: map['order_index'],
    );
  }

  Map<String, dynamic> toMap() => {
    'subchapter_id': subchapterId,
    'chapter_id': chapterId,
    'title': title,
    'description': description,
    'has_collection': hasCollection,
    'order_index': orderIndex,
  };

  SubChapterEntity toEntity() => SubChapterEntity(
    subchapterId: subchapterId,
    chapterId: chapterId,
    title: title,
    description: description,
    hasCollection: hasCollection,
    orderIndex: orderIndex,
  );

  factory SubChapterModel.fromEntity(SubChapterEntity entity) =>
      SubChapterModel(
        subchapterId: entity.subchapterId,
        chapterId: entity.chapterId,
        title: entity.title,
        description: entity.description,
        hasCollection: entity.hasCollection,
        orderIndex: entity.orderIndex,
      );
}
