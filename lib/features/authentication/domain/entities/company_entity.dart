import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/domain/entities/user.dart';

class CompanyEntity extends UserEntity {
  final String companyDescription;
  final String websiteUrl;
  final bool isVerified;

  CompanyEntity({
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
  CompanyEntity copyWith({
    String? userId,
    String? email,
    String? name,
    String? role,
    Timestamp? createdAt,
    String? profileImage,
    String? bio,
    String? companyDescription,
    String? websiteUrl,
    bool? isVerified,
  }) {
    return CompanyEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      profileImage: profileImage ?? this.profileImage,
      companyDescription: companyDescription ?? this.companyDescription,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
