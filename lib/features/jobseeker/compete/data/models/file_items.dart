import 'dart:convert';

import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';

class FileItemModel {
  final String fileName;
  final String extension;
  final String url;

  FileItemModel({
    required this.fileName,
    required this.extension,
    required this.url,
  });

  Map<String, String> toMap() {
    return {'fileName': fileName, 'extension': extension, 'url': url};
  }

  factory FileItemModel.fromMap(Map<String, dynamic> map) {
    return FileItemModel(
      fileName: map['fileName'] ?? '',
      extension: map['extension'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FileItemModel.fromJson(String source) =>
      FileItemModel.fromMap(json.decode(source));

  FileItemEntity toEntity() {
    return FileItemEntity(fileName: fileName, extension: extension, url: url);
  }

  factory FileItemModel.fromEntity(FileItemEntity entity) {
    return FileItemModel(
      fileName: entity.fileName,
      extension: entity.extension,
      url: entity.url,
    );
  }
}
