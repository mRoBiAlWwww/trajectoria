import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competition_participants.dart';

class CompetitionParticipantsModel {
  final String competitionParticipantId;
  final String competitionId;
  final String userId;
  final Timestamp createdAt;

  CompetitionParticipantsModel({
    required this.competitionParticipantId,
    required this.competitionId,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'competition_participants_id': competitionParticipantId,
      'competition_id': competitionId,
      'user_id': userId,
      'created_at': createdAt,
    };
  }

  factory CompetitionParticipantsModel.fromMap(Map<String, dynamic> map) {
    return CompetitionParticipantsModel(
      competitionParticipantId:
          map['competition_participants_id']?.toString() ?? '',
      competitionId: map['competition_id']?.toString() ?? '',
      userId: map['user_id'] ?? '',
      createdAt: map['created_at'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompetitionParticipantsModel.fromJson(String source) =>
      CompetitionParticipantsModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

extension CompetitionParticipantsXModel on CompetitionParticipantsModel {
  CompetitionParticipantsEntity toEntity() {
    return CompetitionParticipantsEntity(
      competitionId: competitionId,
      competitionParticipantId: competitionParticipantId,
      userId: userId,
      createdAt: createdAt,
    );
  }
}
