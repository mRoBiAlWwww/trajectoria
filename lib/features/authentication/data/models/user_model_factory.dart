import 'package:trajectoria/features/authentication/data/models/company.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/authentication/data/models/user.dart';
import 'package:trajectoria/features/authentication/domain/entities/company_entity.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/authentication/domain/entities/user.dart';

class UserModelFactory {
  static UserModel fromMap(Map<String, dynamic> map) {
    final role = map['role'];
    if (role == 'company') {
      return CompanyModel.fromMap(map);
    } else {
      return JobSeekerModel.fromMap(map);
    }
  }

  static UserModel fromEntity(UserEntity entity) {
    if (entity.role == 'company') {
      return CompanyModel.fromEntity(entity as CompanyEntity);
    } else {
      return JobSeekerModel.fromEntity(entity as JobSeekerEntity);
    }
  }
}
