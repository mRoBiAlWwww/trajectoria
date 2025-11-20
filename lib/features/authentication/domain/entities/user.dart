import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserEntity {
  final String userId;
  final String email;
  final String name;
  final String role;
  final String profileImage;
  final Timestamp createdAt;

  UserEntity({
    required this.userId,
    required this.email,
    required this.profileImage,
    required this.name,
    required this.role,
    required this.createdAt,
  });
}
