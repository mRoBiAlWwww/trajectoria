import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/data/models/company.dart';
import 'package:trajectoria/features/authentication/domain/entities/company_entity.dart';

class CompanySignupReq {
  final String email;
  final String role;
  final String name;
  final String? imageUrl;
  final String? userId;
  final Timestamp? createdAt;
  final bool? isVerified;
  final String? companyDescription;
  final String? websiteUrl;

  CompanySignupReq({
    required this.email,
    required this.name,
    required this.role,
    this.userId,
    this.imageUrl,
    this.createdAt,
    this.isVerified,
    this.companyDescription,
    this.websiteUrl,
  });

  CompanyModel toCompanyModel() {
    return CompanyModel(
      userId: userId ?? '',
      email: email.trim(),
      name: name,
      role: role,
      createdAt: createdAt ?? Timestamp.now(),
      profileImage: imageUrl ?? '',
      companyDescription: '',
      websiteUrl: '',
      isVerified: false,
    );
  }

  CompanyEntity toCompanyEntity() {
    return CompanyEntity(
      userId: userId ?? '',
      email: email.trim(),
      name: name,
      role: role,
      createdAt: createdAt ?? Timestamp.now(),
      profileImage: imageUrl ?? '',
      companyDescription: '',
      websiteUrl: '',
      isVerified: false,
    );
  }
}
