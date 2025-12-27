import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementEntity {
  final String? announcementId;
  final String companyName;
  final String competitionName;
  final String submissionId;
  final String competitionId;
  final String userId;
  final Timestamp? createdAnnouncementAt;
  final bool isRead;

  AnnouncementEntity({
    this.announcementId,
    required this.companyName,
    required this.competitionName,
    required this.submissionId,
    required this.competitionId,
    required this.userId,
    this.createdAnnouncementAt,
    required this.isRead,
  });

  AnnouncementEntity copyWith({
    String? announcementId,
    String? companyName,
    String? competitionName,
    String? submissionId,
    String? competitionId,
    String? userId,
    Timestamp? createdAnnouncementAt,
    bool? isRead,
  }) {
    return AnnouncementEntity(
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
}
