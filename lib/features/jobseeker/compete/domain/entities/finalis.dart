import 'package:cloud_firestore/cloud_firestore.dart';

class FinalisEntity {
  final String finalisId;
  final String competitionId;
  final String submissionId;
  final Timestamp submittedAt;
  final String imageUrl;
  final String name;
  final double score;

  FinalisEntity({
    required this.finalisId,
    required this.submissionId,
    required this.competitionId,
    required this.submittedAt,
    required this.imageUrl,
    required this.name,
    required this.score,
  });

  FinalisEntity copyWith({
    String? finalisId,
    String? submissionId,
    String? competitionId,
    Timestamp? submittedAt,
    String? imageUrl,
    String? name,
    double? score,
  }) {
    return FinalisEntity(
      submissionId: submissionId ?? this.submissionId,
      competitionId: competitionId ?? this.competitionId,
      score: score ?? this.score,
      submittedAt: submittedAt ?? this.submittedAt,
      name: name ?? this.name,
      finalisId: finalisId ?? this.finalisId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
