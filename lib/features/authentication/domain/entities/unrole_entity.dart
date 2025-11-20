import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';

import 'user.dart';

class UnroleEntity extends UserEntity {
  UnroleEntity({
    required super.userId,
    required super.email,
    required super.name,
    required super.role,
    required super.createdAt,
    required super.profileImage,
  });

  JobseekerSignupReq toJobseekerSignupReq() {
    return JobseekerSignupReq(
      userId: userId,
      email: email,
      name: name,
      imageUrl: profileImage,
      createdAt: createdAt,
      role: 'Jobseeker',
      bio: '',
      cvFilePath: '',
      skillSummary: '',
      experienceSummary: '',
      statusEmployment: '',
    );
  }

  CompanySignupReq toCompanySignupReq() {
    return CompanySignupReq(
      userId: userId,
      email: email,
      name: name,
      imageUrl: profileImage,
      createdAt: createdAt,
      role: 'Company',
      isVerified: false,
      companyDescription: '',
      websiteUrl: '',
    );
  }
}
