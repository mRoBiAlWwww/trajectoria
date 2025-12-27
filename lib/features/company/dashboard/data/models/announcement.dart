import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/company/dashboard/domain/entities/announcement.dart';

class AnnouncementModel {
  final String announcementId;
  final String companyName;
  final String competitionName;
  final String submissionId;
  final String competitionId;
  final String userId;
  final Timestamp createdAnnouncementAt;
  final bool isRead;

  AnnouncementModel({
    required this.announcementId,
    required this.companyName,
    required this.competitionName,
    required this.submissionId,
    required this.competitionId,
    required this.userId,
    required this.createdAnnouncementAt,
    required this.isRead,
  });

  AnnouncementModel copyWith({
    String? announcementId,
    String? companyName,
    String? competitionName,
    String? submissionId,
    String? competitionId,
    String? userId,
    Timestamp? createdAnnouncementAt,
    bool? isRead,
  }) {
    return AnnouncementModel(
      announcementId: announcementId ?? this.announcementId,
      companyName: companyName ?? this.companyName,
      competitionName: competitionName ?? this.competitionName,
      submissionId: submissionId ?? this.submissionId,
      competitionId: competitionId ?? this.competitionId,
      userId: userId ?? this.userId,
      createdAnnouncementAt:
          createdAnnouncementAt ?? this.createdAnnouncementAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'announcement_id': announcementId,
      'company_name': companyName,
      'competition_name': competitionName,
      'submissions_id': submissionId,
      'competition_id': competitionId,
      'user_id': userId,
      'created_announcement_at': createdAnnouncementAt,
      'is_read': isRead,
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      announcementId: map['announcement_id'] ?? '',
      companyName: map['company_name'] ?? '',
      competitionName: map['competition_name'] ?? '',
      submissionId: map['submissions_id'] ?? '',
      competitionId: map['competition_id'] ?? '',
      userId: map['user_id'] ?? '',
      createdAnnouncementAt: map['created_announcement_at'] ?? '',
      isRead: map['is_read'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AnnouncementModel.fromJson(String source) =>
      AnnouncementModel.fromMap(json.decode(source));

  AnnouncementEntity toEntity() {
    return AnnouncementEntity(
      announcementId: announcementId,
      companyName: companyName,
      competitionName: competitionName,
      submissionId: submissionId,
      competitionId: competitionId,
      userId: userId,
      createdAnnouncementAt: createdAnnouncementAt,
      isRead: isRead,
    );
  }

  factory AnnouncementModel.fromEntity(AnnouncementEntity entity) {
    return AnnouncementModel(
      announcementId: entity.announcementId ?? "",
      companyName: entity.companyName,
      competitionName: entity.competitionName,
      submissionId: entity.submissionId,
      competitionId: entity.competitionId,
      userId: entity.userId,
      createdAnnouncementAt: Timestamp.now(),
      isRead: entity.isRead,
    );
  }
}
