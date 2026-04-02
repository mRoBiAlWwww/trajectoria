import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/certificate.dart';

class CertificateModel {
  final String certificateId;
  final String competitionId;
  final String userId;
  final String competitionName;
  final String companyName;
  final int rank;
  final int topN;
  final Timestamp issuedAt;

  CertificateModel({
    required this.certificateId,
    required this.competitionId,
    required this.userId,
    required this.competitionName,
    required this.companyName,
    required this.rank,
    required this.topN,
    required this.issuedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'certificate_id': certificateId,
      'competition_id': competitionId,
      'user_id': userId,
      'competition_name': competitionName,
      'company_name': companyName,
      'rank': rank,
      'top_n': topN,
      'issued_at': issuedAt,
    };
  }

  factory CertificateModel.fromMap(Map<String, dynamic> map) {
    return CertificateModel(
      certificateId: map['certificate_id'] ?? '',
      competitionId: map['competition_id'] ?? '',
      userId: map['user_id'] ?? '',
      competitionName: map['competition_name'] ?? '',
      companyName: map['company_name'] ?? '',
      rank: (map['rank'] as num?)?.toInt() ?? 0,
      topN: (map['top_n'] as num?)?.toInt() ?? 10,
      issuedAt: map['issued_at'] as Timestamp? ?? Timestamp.now(),
    );
  }

  String toJson() => json.encode({
        'certificate_id': certificateId,
        'competition_id': competitionId,
        'user_id': userId,
        'competition_name': competitionName,
        'company_name': companyName,
        'rank': rank,
        'top_n': topN,
      });

  CertificateEntity toEntity() {
    return CertificateEntity(
      certificateId: certificateId,
      competitionId: competitionId,
      userId: userId,
      competitionName: competitionName,
      companyName: companyName,
      rank: rank,
      topN: topN,
      issuedAt: issuedAt,
    );
  }

  factory CertificateModel.fromEntity(CertificateEntity entity) {
    return CertificateModel(
      certificateId: entity.certificateId,
      competitionId: entity.competitionId,
      userId: entity.userId,
      competitionName: entity.competitionName,
      companyName: entity.companyName,
      rank: entity.rank,
      topN: entity.topN,
      issuedAt: entity.issuedAt,
    );
  }
}
