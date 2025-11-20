import 'package:trajectoria/features/jobseeker/compete/data/models/file_items.dart';

class FileItemEntity {
  final String fileName;
  final String extension;
  final String url;

  FileItemEntity({
    required this.fileName,
    required this.extension,
    required this.url,
  });

  FileItemEntity copyWith({String? fileName, String? extension, String? url}) {
    return FileItemEntity(
      fileName: fileName ?? this.fileName,
      extension: extension ?? this.extension,
      url: url ?? this.url,
    );
  }

  /// 🔹 Convert ke Map (misal untuk Firestore / JSON)
  Map<String, String> toMap() {
    return {'fileName': fileName, 'extension': extension, 'url': url};
  }

  /// 🔹 Convert dari Map (misal hasil dari Firestore / API)
  factory FileItemEntity.fromMap(Map<String, dynamic> map) {
    return FileItemEntity(
      fileName: map['fileName'] ?? '',
      extension: map['extension'] ?? '',
      url: map['url'] ?? '',
    );
  }

  FileItemModel toModel() {
    return FileItemModel(fileName: fileName, extension: extension, url: url);
  }
}
