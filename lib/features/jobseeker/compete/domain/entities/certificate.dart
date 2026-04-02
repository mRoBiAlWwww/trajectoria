import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateEntity {
  final String certificateId;
  final String competitionId;
  final String userId;
  final String competitionName;
  final String companyName;
  final int rank;
  final int topN;
  final Timestamp issuedAt;

  CertificateEntity({
    required this.certificateId,
    required this.competitionId,
    required this.userId,
    required this.competitionName,
    required this.companyName,
    required this.rank,
    required this.topN,
    required this.issuedAt,
  });

  CertificateEntity copyWith({
    String? certificateId,
    String? competitionId,
    String? userId,
    String? competitionName,
    String? companyName,
    int? rank,
    int? topN,
    Timestamp? issuedAt,
  }) {
    return CertificateEntity(
      certificateId: certificateId ?? this.certificateId,
      competitionId: competitionId ?? this.competitionId,
      userId: userId ?? this.userId,
      competitionName: competitionName ?? this.competitionName,
      companyName: companyName ?? this.companyName,
      rank: rank ?? this.rank,
      topN: topN ?? this.topN,
      issuedAt: issuedAt ?? this.issuedAt,
    );
  }
}
