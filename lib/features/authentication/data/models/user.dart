import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/domain/entities/user.dart';

abstract class UserModel {
  final String userId;
  final String email;
  final String name;
  final String role;
  final String profileImage;
  final Timestamp createdAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.role,
    required this.profileImage,
    required this.createdAt,
  });

  Map<String, dynamic> toMap();
  UserEntity toEntity();
}
