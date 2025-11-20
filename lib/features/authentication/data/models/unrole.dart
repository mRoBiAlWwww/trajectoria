import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trajectoria/features/authentication/domain/entities/unrole_entity.dart';

class UnroleModel {
  final String userId;
  final String email;
  final String name;
  final String role;
  final Timestamp createdAt;
  final String profileImage;

  const UnroleModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.profileImage,
  });

  /// 🔁 Konversi dari Firestore map
  factory UnroleModel.fromMap(Map<String, dynamic> map) {
    return UnroleModel(
      userId: map['user_id']?.toString() ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'Unrole',
      createdAt: map['created_at'] is Timestamp
          ? map['created_at'] as Timestamp
          : Timestamp.now(),
      profileImage: map['profileImage'] ?? '',
    );
  }

  /// 🔁 Konversi ke Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'name': name,
      'role': role,
      'created_at': createdAt,
      'profileImage': profileImage,
    };
  }
}

extension UnroleXModel on UnroleModel {
  /// 🔁 Convert ke entity
  UnroleEntity toEntity() {
    return UnroleEntity(
      userId: userId,
      email: email,
      name: name,
      role: role,
      createdAt: createdAt,
      profileImage: profileImage,
    );
  }
}

extension UnroleXEntity on UnroleEntity {
  /// 🔁 Convert dari entity ke model
  UnroleModel toModel() {
    return UnroleModel(
      userId: userId,
      email: email,
      name: name,
      role: role,
      createdAt: createdAt,
      profileImage: profileImage,
    );
  }
}
