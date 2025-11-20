import 'dart:convert';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/insightAI.dart';

class InsightAIModel {
  final List<String> commonPattern;
  final List<String> summary;

  InsightAIModel({required this.commonPattern, required this.summary});

  Map<String, dynamic> toMap() {
    return {'common_pattern': commonPattern, 'summary': summary};
  }

  factory InsightAIModel.fromMap(Map<String, dynamic> map) {
    return InsightAIModel(
      commonPattern: map['common_pattern'] != null
          ? List<String>.from(map['common_pattern'])
          : [],
      summary: map['summary'] != null ? List<String>.from(map['summary']) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory InsightAIModel.fromJson(String source) =>
      InsightAIModel.fromMap(json.decode(source));

  InsightAIEntity toEntity() {
    return InsightAIEntity(commonPattern: commonPattern, summary: summary);
  }

  factory InsightAIModel.fromEntity(InsightAIEntity entity) {
    return InsightAIModel(
      commonPattern: entity.commonPattern,
      summary: entity.summary,
    );
  }
}
