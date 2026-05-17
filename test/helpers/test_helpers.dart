import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:trajectoria/features/authentication/domain/entities/company_entity.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/rubrik.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course.dart';

class FakeAssetBundle extends CachingAssetBundle {
  static const String _svg =
      '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10"></svg>';

  @override
  Future<ByteData> load(String key) async {
    final bytes = Uint8List.fromList(utf8.encode(_svg));
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return _svg;
  }
}

CompanyEntity buildCompanyEntity() {
  return CompanyEntity(
    userId: 'company-1',
    email: 'company@example.com',
    name: 'Example Co',
    role: 'Company',
    profileImage: '',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(0),
    companyDescription: 'Desc',
    websiteUrl: 'https://example.com',
    isVerified: true,
  );
}

CompetitionEntity buildCompetitionEntity({String id = 'comp-1'}) {
  return CompetitionEntity(
    competitionId: id,
    companyId: 'company-1',
    companyName: 'Example Co',
    companyEmail: 'company@example.com',
    companyProfileImage: '',
    title: 'Title',
    description: 'Desc',
    problemStatement: 'Problem',
    deadline: Timestamp.fromMillisecondsSinceEpoch(1000),
    rewardDescription: 'Reward',
    submissionType: 'File',
    status: 'Open',
    categoryId: 'cat-1',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(0),
    competitionImage: '',
    guidebook: <FileItemEntity>[],
    rubrik: <RubrikItemEntity>[],
  );
}

CourseEntity buildCourseEntity({String id = 'course-1'}) {
  return CourseEntity(
    courseId: id,
    title: 'Course',
    description: 'Desc',
    level: 'Beginner',
    createdAt: Timestamp.fromMillisecondsSinceEpoch(0),
    hasCollection: false,
    orderIndex: 1,
  );
}
