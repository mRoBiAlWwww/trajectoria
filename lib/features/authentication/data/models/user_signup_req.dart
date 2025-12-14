import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';
import 'package:trajectoria/features/authentication/domain/entities/company_entity.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';

class UserSignupReq {
  String email;
  String? password;
  String? role;
  String? firstname;
  String? lastname;
  String? imageUrl;

  UserSignupReq({
    required this.email,
    this.password,
    this.role,
    this.firstname,
    this.lastname,
    this.imageUrl,
  });

  String get fullName {
    final f = firstname?.trim() ?? '';
    final l = lastname?.trim() ?? '';
    if (f.isEmpty && l.isEmpty) return '';
    if (f.isEmpty) return l;
    if (l.isEmpty) return f;
    return '$f $l';
  }

  JobseekerSignupReq toJobseekerSignupReq() {
    return JobseekerSignupReq(
      userId: '',
      email: email,
      name: fullName,
      imageUrl: imageUrl ?? '',
      createdAt: Timestamp.now(),
      role: 'Jobseeker',
      bio: '',
      cvFilePath: '',
      skillSummary: '',
      experienceSummary: '',
      statusEmployment: '',
      coursesScore: 0,
      finishedModule: <String>[],
      competitionsOnprogres: <String>[],
      competitionsDone: <String>[],
      finishedSubchapter: <String>[],
      onprogresChapter: <String>[],
    );
  }

  CompanySignupReq toCompanySignupReq() {
    return CompanySignupReq(
      userId: '',
      email: email,
      name: fullName,
      imageUrl: imageUrl ?? '',
      createdAt: Timestamp.now(),
      role: 'Company',
      isVerified: false,
      companyDescription: '',
      websiteUrl: '',
    );
  }
}

extension UserSignupReqX on UserSignupReq {
  JobSeekerEntity toJobseekerEntity() {
    final String fullName = [
      firstname,
      lastname,
    ].where((s) => s != null && s.isNotEmpty).join(' ');
    return JobSeekerEntity(
      userId: '',
      email: email,
      name: fullName.isNotEmpty ? fullName : '',
      role: 'Jobseeker',
      createdAt: Timestamp.now(),
      profileImage: imageUrl ?? '',
      bio: '',
      cvFilePath: '',
      skillSummary: '',
      experienceSummary: '',
      statusEmployment: '',
      coursesScore: 0,
      finishedModule: <String>[],
      competitionsOnprogres: <String>[],
      competitionsDone: <String>[],
      finishedSubchapter: <String>[],
      finishedChapter: <String>[],
      onprogresChapter: <String>[],
    );
  }

  CompanyEntity toCompanyEntity() {
    final String fullName = [
      firstname,
      lastname,
    ].where((s) => s != null && s.isNotEmpty).join(' ');
    return CompanyEntity(
      userId: '',
      email: email,
      name: fullName.isNotEmpty ? fullName : '',
      role: 'Jobseeker',
      createdAt: Timestamp.now(),
      profileImage: imageUrl ?? '',
      companyDescription: '',
      websiteUrl: '',
      isVerified: false,
    );
  }
}
