import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';

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
  final List<String>? competitionsOnprogress;
  final List<String>? competitionsDone;
  final List<String>? finishedSubchapter;

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
    this.competitionsOnprogress,
    this.competitionsDone,
    this.finishedSubchapter,
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
      competitionsOnprogress: competitionsOnprogress ?? <String>[],
      competitionsDone: competitionsDone ?? <String>[],
      finishedSubchapter: finishedSubchapter ?? <String>[],
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
      competitionsOnprogress: competitionsOnprogress ?? <String>[],
      competitionsDone: competitionsDone ?? <String>[],
      finishedSubchapter: finishedSubchapter ?? <String>[],
    );
  }
}
