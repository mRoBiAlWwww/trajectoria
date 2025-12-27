import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/jobseeker/learn/data/models/progres.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/progres.dart';

class JobseekerSignupReq {
  final String email;
  final String role;
  final String name;
  final String? imageUrl;
  final String? userId;
  final Timestamp? createdAt;
  final String? bio;
  final String? cvFilePath;
  final String? skillSummary;
  final String? experienceSummary;
  final String? statusEmployment;
  final int? coursesScore;
  final List<String>? finishedModule;
  final List<String>? competitionsOnprogres;
  final List<String>? competitionsDone;
  final List<String>? finishedSubchapter;
  final List<String>? finishedChapter;
  final String? onprogresChapter;
  final String? tokenNotification;
  final List<String>? bookmarks;
  final List<ProgresModel>? progres;

  JobseekerSignupReq({
    required this.email,
    required this.name,
    required this.role,
    this.createdAt,
    this.imageUrl,
    this.userId,
    this.bio,
    this.cvFilePath,
    this.skillSummary,
    this.experienceSummary,
    this.statusEmployment,
    this.coursesScore,
    this.finishedModule,
    this.competitionsOnprogres,
    this.competitionsDone,
    this.finishedSubchapter,
    this.finishedChapter,
    this.onprogresChapter,
    this.tokenNotification,
    this.bookmarks,
    this.progres,
  });

  JobSeekerModel toJobseekerModel() {
    return JobSeekerModel(
      userId: userId ?? '',
      email: email.trim(),
      name: name,
      role: role,
      createdAt: Timestamp.now(),
      profileImage: imageUrl ?? '',
      bio: '',
      cvFilePath: '',
      skillSummary: '',
      experienceSummary: '',
      statusEmployment: '',
      coursesScore: 0,
      finishedModule: finishedModule ?? <String>[],
      competitionsOnprogres: competitionsOnprogres ?? <String>[],
      competitionsDone: competitionsDone ?? <String>[],
      finishedSubchapter: finishedSubchapter ?? <String>[],
      finishedChapter: finishedChapter ?? <String>[],
      onprogresChapter: '',
      tokenNotification: '',
      bookmarks: bookmarks ?? <String>[],
      progres: progres ?? <ProgresModel>[],
    );
  }

  JobSeekerEntity toJobseekerEntity() {
    return JobSeekerEntity(
      userId: userId ?? '',
      email: email.trim(),
      name: name,
      role: role,
      createdAt: Timestamp.now(),
      profileImage: imageUrl ?? '',
      bio: '',
      cvFilePath: '',
      skillSummary: '',
      experienceSummary: '',
      statusEmployment: '',
      coursesScore: 0,
      finishedModule: finishedModule ?? <String>[],
      competitionsOnprogres: competitionsOnprogres ?? <String>[],
      competitionsDone: competitionsDone ?? <String>[],
      finishedSubchapter: finishedSubchapter ?? <String>[],
      finishedChapter: finishedChapter ?? <String>[],
      onprogresChapter: '',
      tokenNotification: '',
      bookmarks: bookmarks ?? <String>[],
      progres: progres != null
          ? progres!.map((e) => e.toEntity()).toList()
          : <ProgresEntity>[],
    );
  }
}
