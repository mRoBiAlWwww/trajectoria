import 'package:trajectoria/features/jobseeker/compete/data/models/insightAI.dart';

class InsightAIEntity {
  final List<String> commonPattern;
  final List<String> summary;
  final List<String> strengths;
  final List<String> weaknesses;
  final String improvementSuggestion;
  final String careerMatchRecommendation;

  InsightAIEntity({
    required this.commonPattern,
    required this.summary,
    this.strengths = const [],
    this.weaknesses = const [],
    this.improvementSuggestion = '',
    this.careerMatchRecommendation = '',
  });

  InsightAIEntity copyWith({
    List<String>? commonPattern,
    List<String>? summary,
    List<String>? strengths,
    List<String>? weaknesses,
    String? improvementSuggestion,
    String? careerMatchRecommendation,
  }) {
    return InsightAIEntity(
      commonPattern: commonPattern ?? this.commonPattern,
      summary: summary ?? this.summary,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      improvementSuggestion:
          improvementSuggestion ?? this.improvementSuggestion,
      careerMatchRecommendation:
          careerMatchRecommendation ?? this.careerMatchRecommendation,
    );
  }

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

  factory InsightAIEntity.fromMap(Map<String, dynamic> map) {
    return InsightAIEntity(
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

  InsightAIModel toModel() {
    return InsightAIModel(
      commonPattern: commonPattern,
      summary: summary,
      strengths: strengths,
      weaknesses: weaknesses,
      improvementSuggestion: improvementSuggestion,
      careerMatchRecommendation: careerMatchRecommendation,
    );
  }
}
