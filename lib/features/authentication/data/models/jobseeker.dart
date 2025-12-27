import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/data/models/user.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/progres.dart';

class JobSeekerModel extends UserModel {
  final String bio;
  final String cvFilePath;
  final String skillSummary;
  final String experienceSummary;
  final String statusEmployment;
  final int coursesScore;
  final List<String> finishedModule;
  final List<String> competitionsOnprogres;
  final List<String> competitionsDone;
  final List<String> finishedSubchapter;
  final List<String> finishedChapter;
  final String onprogresChapter;
  final String tokenNotification;
  final List<String> bookmarks;
  final List<ProgresModel> progres;

  JobSeekerModel({
    required super.userId,
    required super.email,
    required super.name,
    required super.role,
    required super.profileImage,
    required super.createdAt,
    required this.bio,
    required this.cvFilePath,
    required this.skillSummary,
    required this.experienceSummary,
    required this.statusEmployment,
    required this.coursesScore,
    required this.finishedModule,
    required this.competitionsOnprogres,
    required this.competitionsDone,
    required this.finishedSubchapter,
    required this.finishedChapter,
    required this.onprogresChapter,
    required this.tokenNotification,
    required this.bookmarks,
    required this.progres,
  });

  factory JobSeekerModel.fromMap(Map<String, dynamic> map) {
    return JobSeekerModel(
      userId: map['user_id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'user',
      profileImage: map['profileImage'] ?? '',
      createdAt: map['created_at'] as Timestamp,
      bio: map['bio'] ?? '',
      cvFilePath: map['cv_file_path'] ?? '',
      skillSummary: map['skill_sumarry'] ?? '',
      experienceSummary: map['experience_sumarry'] ?? '',
      statusEmployment: map['status_employment'] ?? '',
      coursesScore: (map['courses_score'] as num?)?.toInt() ?? 0,
      finishedModule: map['finished_module'] != null
          ? List<String>.from(map['finished_module'] as List)
          : <String>[],
      competitionsOnprogres: map['competitions_onprogres'] != null
          ? List<String>.from(map['competitions_onprogres'] as List)
          : <String>[],
      competitionsDone: map['competitions_done'] != null
          ? List<String>.from(map['competitions_done'] as List)
          : <String>[],
      finishedSubchapter: map['finished_subchapter'] != null
          ? List<String>.from(map['finished_subchapter'] as List)
          : <String>[],
      finishedChapter: map['finished_chapter'] != null
          ? List<String>.from(map['finished_chapter'] as List)
          : <String>[],
      onprogresChapter: map['onprogres_chapter'] ?? '',
      tokenNotification: map['token_notification'] ?? '',
      bookmarks: map['bookmarks'] != null
          ? List<String>.from(map['bookmarks'] as List)
          : <String>[],
      progres: map['progres'] != null
          ? (map['progres'] as List)
                .map((e) => ProgresModel.fromMap(Map<String, dynamic>.from(e)))
                .toList()
          : [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'name': name,
      'role': role,
      'created_at': createdAt,
      'profileImage': profileImage,
      'bio': bio,
      'cv_file_path': cvFilePath,
      'skill_sumarry': skillSummary,
      'experience_sumarry': experienceSummary,
      'status_employment': statusEmployment,
      'courses_score': coursesScore,
      'finished_module': finishedModule,
      'competitions_onprogres': competitionsOnprogres,
      'competitions_done': competitionsDone,
      'finished_subchapter': finishedSubchapter,
      'finished_chapter': finishedChapter,
      'onprogres_chapter': onprogresChapter,
      'token_notification': tokenNotification,
      'bookmarks': bookmarks,
      'progres': progres.map((e) => e.toMap()).toList(),
    };
  }

  factory JobSeekerModel.fromEntity(JobSeekerEntity entity) {
    return JobSeekerModel(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      role: entity.role,
      createdAt: entity.createdAt,
      bio: entity.bio,
      cvFilePath: entity.cvFilePath,
      skillSummary: entity.skillSummary,
      experienceSummary: entity.experienceSummary,
      statusEmployment: entity.statusEmployment,
      profileImage: entity.profileImage,
      coursesScore: entity.coursesScore,
      finishedModule: entity.finishedModule,
      competitionsOnprogres: entity.competitionsOnprogres,
      competitionsDone: entity.competitionsDone,
      finishedSubchapter: entity.finishedSubchapter,
      finishedChapter: entity.finishedChapter,
      onprogresChapter: entity.onprogresChapter,
      tokenNotification: entity.tokenNotification,
      bookmarks: entity.bookmarks,
      progres: entity.progres.map((e) => ProgresModel.fromEntity(e)).toList(),
    );
  }

  @override
  JobSeekerEntity toEntity() {
    return JobSeekerEntity(
      userId: userId,
      email: email,
      name: name,
      role: role,
      profileImage: profileImage,
      createdAt: createdAt,
      bio: bio,
      cvFilePath: cvFilePath,
      skillSummary: skillSummary,
      experienceSummary: experienceSummary,
      statusEmployment: statusEmployment,
      coursesScore: coursesScore,
      finishedModule: finishedModule,
      competitionsOnprogres: competitionsOnprogres,
      competitionsDone: competitionsDone,
      finishedSubchapter: finishedSubchapter,
      finishedChapter: finishedChapter,
      onprogresChapter: onprogresChapter,
      tokenNotification: tokenNotification,
      bookmarks: bookmarks,
      progres: progres.map((e) => e.toEntity()).toList(),
    );
  }
}
