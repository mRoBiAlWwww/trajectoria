import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/rubrik.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

class CompetitionModel {
  final String competitionId;
  final String companyId;
  final String companyName;
  final String companyEmail;
  final String companyProfileImage;
  final String title;
  final String description;
  final String problemStatement;
  final Timestamp deadline;
  final String rewardDescription;
  final String submissionType;
  final String status;
  final String categoryId;
  final Timestamp createdAt;
  final String competitionImage;
  final List<FileItemModel> guidebook;
  final List<RubrikItemModel> rubrik;

  CompetitionModel({
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
  CompetitionModel copyWith({
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
    List<FileItemModel>? guidebook,
    List<RubrikItemModel>? rubrik,
  }) {
    return CompetitionModel(
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
      'deadline': deadline,
      'reward_description': rewardDescription,
      'submission_type': submissionType,
      'status': status,
      'category_id': categoryId,
      'created_at': createdAt,
      'competition_image': competitionImage,
      'guidebook': guidebook.map((g) => g.toMap()).toList(),
      'rubrik': rubrik.map((g) => g.toMap()).toList(),
    };
  }

  factory CompetitionModel.fromMap(Map<String, dynamic> map) {
    return CompetitionModel(
      competitionId: map['competition_id']?.toString() ?? '',
      companyId: map['company_id']?.toString() ?? '',
      companyName: map['company_name']?.toString() ?? '',
      companyEmail: map['company_email']?.toString() ?? '',
      companyProfileImage: map['company_profile_image']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      problemStatement: map['problem_statement'] ?? '',
      deadline: map['deadline'] as Timestamp,
      rewardDescription: map['reward_description'] ?? '',
      submissionType: map['submission_type'] ?? '',
      status: map['status'] ?? '',
      categoryId: map['category_id'] ?? '',
      createdAt: map['created_at'] as Timestamp,
      competitionImage: map['competition_image'] ?? '',
      // competitionImage: map['competition_images'] != null
      //     ? List<String>.from(map['competition_images'])
      //     : [],
      rubrik: map['rubrik'] != null
          ? (map['rubrik'] as List)
                .map(
                  (e) => RubrikItemModel.fromMap(Map<String, dynamic>.from(e)),
                )
                .toList()
          : [],
      guidebook: map['guidebook'] != null
          ? (map['guidebook'] as List)
                .map((e) => FileItemModel.fromMap(Map<String, String>.from(e)))
                .toList()
          : [],
      // guidebook: map['guidebook'] != null
      //     ? (map['guidebook'] as List)
      //           .map((e) => GuidebookItem.fromMap(Map<String, dynamic>.from(e)))
      //           .toList()
      //     : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CompetitionModel.fromJson(String source) =>
      CompetitionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory CompetitionModel.fromEntity(CompetitionEntity entity) {
    return CompetitionModel(
      competitionId: entity.competitionId,
      companyId: entity.companyId,
      companyName: entity.companyName,
      companyEmail: entity.companyEmail,
      companyProfileImage: entity.companyProfileImage,
      title: entity.title,
      description: entity.description,
      problemStatement: entity.problemStatement,
      deadline: entity.deadline,
      rewardDescription: entity.rewardDescription,
      submissionType: entity.submissionType,
      status: entity.status,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt,
      competitionImage: entity.competitionImage,
      guidebook: entity.guidebook
          .map((e) => FileItemModel.fromEntity(e))
          .toList(),
      rubrik: entity.rubrik.map((e) => RubrikItemModel.fromEntity(e)).toList(),
    );
  }
}

extension CompetitionXModel on CompetitionModel {
  CompetitionEntity toEntity() {
    return CompetitionEntity(
      competitionId: competitionId,
      companyId: companyId,
      companyName: companyName,
      companyEmail: companyEmail,
      companyProfileImage: companyProfileImage,
      title: title,
      description: description,
      problemStatement: problemStatement,
      deadline: deadline,
      rewardDescription: rewardDescription,
      submissionType: submissionType,
      status: status,
      categoryId: categoryId,
      createdAt: createdAt,
      competitionImage: competitionImage,
      guidebook: guidebook.map((e) => e.toEntity()).toList(),
      rubrik: rubrik.map((e) => e.toEntity()).toList(),
    );
  }
}
