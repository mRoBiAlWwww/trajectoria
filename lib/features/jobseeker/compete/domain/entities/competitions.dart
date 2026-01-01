import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/rubrik.dart';

class CompetitionEntity {
  final String competitionId;
  final String companyId;
  final String companyName;
  final String companyEmail;
  final String companyProfileImage;
  final String description;
  final Timestamp createdAt;
  final Timestamp deadline;
  final String title;
  final String problemStatement;
  final String rewardDescription;
  final String submissionType;
  final String status;
  final String categoryId;
  final String competitionImage;
  final List<FileItemEntity> guidebook;
  final List<RubrikItemEntity> rubrik;

  CompetitionEntity({
    required this.competitionId,
    required this.companyId,
    required this.companyName,
    required this.companyEmail,
    required this.companyProfileImage,
    required this.title,
    required this.description,
    required this.problemStatement,
    required this.deadline,
    required this.rewardDescription,
    required this.submissionType,
    required this.status,
    required this.categoryId,
    required this.createdAt,
    required this.competitionImage,
    required this.guidebook,
    required this.rubrik,
  });

  /// ✅ Membuat salinan dengan perubahan sebagian field
  CompetitionEntity copyWith({
    String? competitionId,
    String? companyId,
    String? companyName,
    String? companyEmail,
    String? companyProfileImage,
    String? title,
    String? description,
    String? problemStatement,
    Timestamp? deadline,
    String? rewardDescription,
    String? submissionType,
    String? status,
    String? categoryId,
    Timestamp? createdAt,
    String? competitionImage,
    List<FileItemEntity>? guidebook,
    final List<RubrikItemEntity>? rubrik,

    // List<GuidebookItem>? guidebook,
  }) {
    return CompetitionEntity(
      competitionId: competitionId ?? this.competitionId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      companyEmail: companyEmail ?? this.companyEmail,
      companyProfileImage: companyProfileImage ?? this.companyProfileImage,
      title: title ?? this.title,
      description: description ?? this.description,
      problemStatement: problemStatement ?? this.problemStatement,
      deadline: deadline ?? this.deadline,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      submissionType: submissionType ?? this.submissionType,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      competitionImage: competitionImage ?? this.competitionImage,
      guidebook: guidebook ?? this.guidebook,
      rubrik: rubrik ?? this.rubrik,
    );
  }

  /// ✅ Konversi ke Map (untuk JSON / Firestore / API)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'competition_id': competitionId,
      'company_id': companyId,
      'company_name': companyName,
      'company_email': companyEmail,
      'company_profile_image': companyProfileImage,
      'title': title,
      'description': description,
      'problem_statement': problemStatement,
      'deadline': deadline.millisecondsSinceEpoch,
      // 'deadline': deadline,
      'reward_description': rewardDescription,
      'submission_type': submissionType,
      'status': status,
      'category_id': categoryId,
      'created_at': createdAt.millisecondsSinceEpoch,
      // 'created_at': createdAt,
      'competition_image': competitionImage,
      'guidebook': guidebook.map((g) => g.toMap()).toList(),
      'rubrik': rubrik.map((g) => g.toMap()).toList(),
    };
  }

  /// ✅ Factory dari Map
  factory CompetitionEntity.fromMap(Map<String, dynamic> map) {
    return CompetitionEntity(
      competitionId: map['competition_id']?.toString() ?? '',
      companyId: map['company_id']?.toString() ?? '',
      companyName: map['company_name']?.toString() ?? '',
      companyEmail: map['company_email']?.toString() ?? '',
      companyProfileImage: map['company_profile_image']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      problemStatement: map['problem_statement'] ?? '',
      deadline: Timestamp.fromMillisecondsSinceEpoch(map['deadline'] as int),
      // deadline: map['deadline'] as Timestamp,
      rewardDescription: map['reward_description'] ?? '',
      submissionType: map['submission_type'] ?? '',
      status: map['status'] ?? '',
      categoryId: map['category_id'] ?? '',
      createdAt: Timestamp.fromMillisecondsSinceEpoch(map['created_at'] as int),
      // createdAt: map['created_at'] as Timestamp,
      competitionImage: map['competition_image'] ?? '',
      // competitionImage: map['competition_images'] != null
      //     ? List<String>.from(map['competition_images'])
      //     : [],
      rubrik: map['rubrik'] != null
          ? (map['rubrik'] as List)
                .map(
                  (e) => RubrikItemEntity.fromMap(Map<String, dynamic>.from(e)),
                )
                .toList()
          : [],
      guidebook: map['guidebook'] != null
          ? (map['guidebook'] as List)
                .map((e) => FileItemEntity.fromMap(Map<String, String>.from(e)))
                .toList()
          : [],
    );
  }
}
