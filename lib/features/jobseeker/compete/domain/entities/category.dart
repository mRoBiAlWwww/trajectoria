import 'package:trajectoria/features/jobseeker/compete/data/models/category.dart';

class CategoryEntity {
  final String category;
  final String imageUrl;
  final String categoryId;

  CategoryEntity({
    required this.category,
    required this.imageUrl,
    required this.categoryId,
  });

  CategoryEntity copyWith({
    String? category,
    String? imageUrl,
    String? categoryId,
  }) {
    return CategoryEntity(
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  /// 🔹 Convert ke Map (misal untuk Firestore / JSON)
  Map<String, String> toMap() {
    return {
      'category': category,
      'imageUrl': imageUrl,
      'category_id': categoryId,
    };
  }

  /// 🔹 Convert dari Map (misal hasil dari Firestore / API)
  factory CategoryEntity.fromMap(Map<String, String> map) {
    return CategoryEntity(
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      categoryId: map['category_id'] ?? '',
    );
  }

  CategoryModel toModel() {
    return CategoryModel(
      category: category,
      imageUrl: imageUrl,
      categoryId: categoryId,
    );
  }
}
