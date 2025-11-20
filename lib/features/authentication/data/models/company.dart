import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/data/models/user.dart';
import 'package:trajectoria/features/authentication/domain/entities/company_entity.dart';

class CompanyModel extends UserModel {
  final String companyDescription;
  final String websiteUrl;
  final bool isVerified;

  CompanyModel({
    required super.userId,
    required super.email,
    required super.name,
    required super.role,
    required super.createdAt,
    required super.profileImage,
    required this.companyDescription,
    required this.websiteUrl,
    required this.isVerified,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      userId: map['user_id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'company',
      createdAt: map['created_at'] as Timestamp,
      companyDescription: map['company_description'] ?? '',
      websiteUrl: map['website_url'] ?? '',
      profileImage: map['profileImage'] ?? '',
      isVerified: map['is_verified'] ?? false,
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
      'company_description': companyDescription,
      'website_url': websiteUrl,
      'profileImage': profileImage,
      'is_verified': isVerified,
    };
  }

  @override
  CompanyEntity toEntity() {
    return CompanyEntity(
      userId: userId,
      email: email,
      name: name,
      role: role,
      createdAt: createdAt,
      companyDescription: companyDescription,
      websiteUrl: websiteUrl,
      profileImage: profileImage,
      isVerified: isVerified,
    );
  }

  factory CompanyModel.fromEntity(CompanyEntity entity) {
    return CompanyModel(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      role: entity.role,
      createdAt: entity.createdAt,
      companyDescription: entity.companyDescription,
      websiteUrl: entity.websiteUrl,
      profileImage: entity.profileImage,
      isVerified: entity.isVerified,
    );
  }
}
