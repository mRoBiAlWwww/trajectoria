import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/domain/entities/user.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/progres.dart';

class JobSeekerEntity extends UserEntity {
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
  final List<ProgresEntity> progres;

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
    required this.competitionsOnprogres,
    required this.competitionsDone,
    required this.finishedSubchapter,
    required this.finishedChapter,
    required this.onprogresChapter,
    required this.tokenNotification,
    required this.bookmarks,
    required this.progres,
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
    List<String>? competitionsOnprogres,
    List<String>? competitionsDone,
    List<String>? finishedSubchapter,
    List<String>? finishedChapter,
    String? onprogresChapter,
    String? tokenNotification,
    List<String>? bookmarks,
    List<ProgresEntity>? progres,
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
      competitionsOnprogres:
          competitionsOnprogres ?? this.competitionsOnprogres,
      competitionsDone: competitionsDone ?? this.competitionsDone,
      finishedSubchapter: finishedSubchapter ?? this.finishedSubchapter,
      finishedChapter: finishedChapter ?? this.finishedChapter,
      onprogresChapter: onprogresChapter ?? this.onprogresChapter,
      tokenNotification: tokenNotification ?? this.tokenNotification,
      bookmarks: bookmarks ?? this.bookmarks,
      progres: progres ?? this.progres,
    );
  }
}
