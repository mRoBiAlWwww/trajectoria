import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/domain/entities/user.dart';

class JobSeekerEntity extends UserEntity {
  final String bio;
  final String cvFilePath;
  final String skillSummary;
  final String experienceSummary;
  final String statusEmployment;
  final int coursesScore;
  final List<String> finishedModule;
  final List<String> competitionsOnprogress;
  final List<String> competitionsDone;

  JobSeekerEntity({
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
    required this.competitionsOnprogress,
    required this.competitionsDone,
  });
  JobSeekerEntity copyWith({
    String? userId,
    String? email,
    String? name,
    String? role,
    Timestamp? createdAt,
    String? profileImage,
    String? bio,
    String? cvFilePath,
    String? skillSummary,
    String? experienceSummary,
    String? statusEmployment,
    int? coursesScore,
    List<String>? finishedModule,
    List<String>? competitionsOnprogress,
    List<String>? competitionsDone,
  }) {
    return JobSeekerEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      cvFilePath: cvFilePath ?? this.cvFilePath,
      skillSummary: skillSummary ?? this.skillSummary,
      experienceSummary: experienceSummary ?? this.experienceSummary,
      statusEmployment: statusEmployment ?? this.statusEmployment,
      coursesScore: coursesScore ?? this.coursesScore,
      finishedModule: finishedModule ?? this.finishedModule,
      competitionsOnprogress:
          competitionsOnprogress ?? this.competitionsOnprogress,
      competitionsDone: competitionsDone ?? this.competitionsDone,
    );
  }
}
