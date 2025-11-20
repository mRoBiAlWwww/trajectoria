import 'package:trajectoria/features/jobseeker/compete/data/models/insightAI.dart';

class InsightAIEntity {
  final List<String> commonPattern;
  final List<String> summary;

  InsightAIEntity({required this.commonPattern, required this.summary});

  InsightAIEntity copyWith({
    List<String>? commonPattern,
    List<String>? summary,
  }) {
    return InsightAIEntity(
      commonPattern: commonPattern ?? this.commonPattern,
      summary: summary ?? this.summary,
    );
  }

  /// 🔹 Convert ke Map (misal untuk Firestore / JSON)
  Map<String, dynamic> toMap() {
    return {'common_pattern': commonPattern, 'summary': summary};
  }

  /// 🔹 Convert dari Map (misal hasil dari Firestore / API)
  factory InsightAIEntity.fromMap(Map<String, dynamic> map) {
    return InsightAIEntity(
      commonPattern: map['common_pattern'] != null
          ? List<String>.from(map['common_pattern'])
          : [],
      summary: map['summary'] != null ? List<String>.from(map['summary']) : [],
    );
  }

  InsightAIModel toModel() {
    return InsightAIModel(commonPattern: commonPattern, summary: summary);
  }
}
