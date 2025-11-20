import 'dart:convert';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/category.dart';

class CategoryModel {
  final String category;
  final String imageUrl;
  final String categoryId;

  CategoryModel({
    required this.category,
    required this.imageUrl,
    required this.categoryId,
  });

  Map<String, String> toMap() {
    return {
      'category': category,
      'imageUrl': imageUrl,
      'category_id': categoryId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      categoryId: map['category_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  CategoryEntity toEntity() {
    return CategoryEntity(
      category: category,
      imageUrl: imageUrl,
      categoryId: categoryId,
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      category: entity.category,
      imageUrl: entity.imageUrl,
      categoryId: entity.categoryId,
    );
  }
}
