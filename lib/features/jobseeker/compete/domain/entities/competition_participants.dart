import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionParticipantsEntity {
  final String competitionParticipantId;
  final String competitionId;
  final String userId;
  final Timestamp createdAt;

  CompetitionParticipantsEntity({
    required this.competitionParticipantId,
    required this.competitionId,
    required this.userId,
    required this.createdAt,
  });

  CompetitionParticipantsEntity copyWith({
    String? competitionParticipantId,
    String? competitionId,
    String? userId,
    Timestamp? createdAt,
  }) {
    return CompetitionParticipantsEntity(
      competitionParticipantId:
          competitionParticipantId ?? this.competitionParticipantId,
      competitionId: competitionId ?? this.competitionId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap({String? compId}) {
    return <String, dynamic>{
      'competition_participants_id': compId ?? competitionParticipantId,
      'competition_id': competitionId,
      'user_id': userId,
      'created_at': createdAt,
    };
  }

  /// ✅ Factory dari Map
  factory CompetitionParticipantsEntity.fromMap(Map<String, dynamic> map) {
    return CompetitionParticipantsEntity(
      competitionParticipantId:
          map['competition_participants_id']?.toString() ?? '',
      competitionId: map['competition_id']?.toString() ?? '',
      userId: map['user_id'] ?? '',
      createdAt: map['created_at'] as Timestamp,
    );
  }
}
