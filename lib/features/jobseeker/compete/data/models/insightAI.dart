import 'dart:convert';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/insightAI.dart';

class InsightAIModel {
  final List<String> commonPattern;
  final List<String> summary;
  final List<String> strengths;
  final List<String> weaknesses;
  final String improvementSuggestion;
  final String careerMatchRecommendation;

  InsightAIModel({
    required this.commonPattern,
    required this.summary,
    this.strengths = const [],
    this.weaknesses = const [],
    this.improvementSuggestion = '',
    this.careerMatchRecommendation = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'common_pattern': commonPattern,
      'summary': summary,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'improvement_suggestion': improvementSuggestion,
      'career_match_recommendation': careerMatchRecommendation,
    };
  }

  factory InsightAIModel.fromMap(Map<String, dynamic> map) {
    return InsightAIModel(
      commonPattern: map['common_pattern'] != null
          ? List<String>.from(map['common_pattern'])
          : [],
      summary:
          map['summary'] != null ? List<String>.from(map['summary']) : [],
      strengths: map['strengths'] != null
          ? List<String>.from(map['strengths'])
          : [],
      weaknesses: map['weaknesses'] != null
          ? List<String>.from(map['weaknesses'])
          : [],
      improvementSuggestion: map['improvement_suggestion'] ?? '',
      careerMatchRecommendation: map['career_match_recommendation'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InsightAIModel.fromJson(String source) =>
      InsightAIModel.fromMap(json.decode(source));

  InsightAIEntity toEntity() {
    return InsightAIEntity(
      commonPattern: commonPattern,
      summary: summary,
      strengths: strengths,
      weaknesses: weaknesses,
      improvementSuggestion: improvementSuggestion,
      careerMatchRecommendation: careerMatchRecommendation,
    );
  }

  factory InsightAIModel.fromEntity(InsightAIEntity entity) {
    return InsightAIModel(
      commonPattern: entity.commonPattern,
      summary: entity.summary,
      strengths: entity.strengths,
      weaknesses: entity.weaknesses,
      improvementSuggestion: entity.improvementSuggestion,
      careerMatchRecommendation: entity.careerMatchRecommendation,
    );
  }
}
