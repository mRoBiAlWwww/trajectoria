class SubChapterEntity {
  final String subchapterId;
  final String chapterId;
  final String title;
  final String description;
  final bool hasCollection;
  final int orderIndex;

  SubChapterEntity({
    required this.subchapterId,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.hasCollection,
    required this.orderIndex,
  });
}
