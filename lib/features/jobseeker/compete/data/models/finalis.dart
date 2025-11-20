import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/finalis.dart';

class FinalisModel {
  final String finalisId;
  final String competitionId;
  final String submissionId;
  final String imageUrl;
  final Timestamp submittedAt;
  final String name;
  final double score;

  FinalisModel({
    required this.finalisId,
    required this.competitionId,
    required this.submissionId,
    required this.submittedAt,
    required this.imageUrl,
    required this.name,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'finalis_id': finalisId,
      'competition_id': competitionId,
      'submissions_id': submissionId,
      'submitted_at': submittedAt,
      'imageUrl': imageUrl,
      'name': name,
      'score': score,
    };
  }

  factory FinalisModel.fromMap(Map<String, dynamic> map) {
    return FinalisModel(
      finalisId: map['finalis_id'] ?? '',
      submissionId: map['submissions_id'] ?? '',
      competitionId: map['competition_id'] ?? '',
      submittedAt: map['submitted_at'] as Timestamp,
      imageUrl: map['imageUrl'] ?? '',
      name: map['name'] ?? '',
      score: (map['score'] is int)
          ? (map['score'] as int).toDouble()
          : (map['score'] ?? 0.0),
    );
  }

  String toJson() => json.encode(toMap());

  factory FinalisModel.fromJson(String source) =>
      FinalisModel.fromMap(json.decode(source));

  /// Konversi ke entity
  FinalisEntity toEntity() {
    return FinalisEntity(
      finalisId: finalisId,
      submissionId: submissionId,
      competitionId: competitionId,
      submittedAt: submittedAt,
      imageUrl: imageUrl,
      name: name,
      score: score,
    );
  }

  /// Buat dari entity
  factory FinalisModel.fromEntity(FinalisEntity entity) {
    return FinalisModel(
      finalisId: entity.finalisId,
      submissionId: entity.submissionId,
      competitionId: entity.competitionId,
      submittedAt: entity.submittedAt,
      imageUrl: entity.imageUrl,
      score: entity.score,
      name: entity.name,
    );
  }
}
