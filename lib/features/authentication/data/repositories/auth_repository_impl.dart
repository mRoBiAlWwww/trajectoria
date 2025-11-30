import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/datasources/auth_firebase_service.dart';
import 'package:trajectoria/features/authentication/data/models/company.dart';
import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/unrole.dart';
import 'package:trajectoria/features/authentication/data/models/user_signin_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthFirebaseService service;
  AuthRepositoryImpl({required this.service});

  @override
  Future<Either> signup(UserSignupReq user) async {
    try {
      final result = await service.signup(user);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> resendVerificationEmail() async {
    try {
      final result = await service.resendVerificationEmail();
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> additionalUserInfoJobSeeker(JobseekerSignupReq user) async {
    try {
      final result = await service.additionalUserInfoJobSeeker(user);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> additionalUserInfoCompany(CompanySignupReq user) async {
    try {
      final result = await service.additionalUserInfoCompany(user);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> forgotPassword(String email) async {
    try {
      final result = await service.forgotPassword(email);
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    try {
      final (raw, role) = await service.signin(user);

      if (role == "Jobseeker") {
        return Right(JobSeekerModel.fromMap(raw).toEntity());
      } else {
        return Right(CompanyModel.fromMap(raw).toEntity());
      }
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> signInWithGoogle(String role) async {
    try {
      final (raw, userRole) = await service.signInWithGoogle(role);

      if (userRole == "Jobseeker") {
        return Right(JobSeekerModel.fromMap(raw).toEntity());
      } else {
        return Right(CompanyModel.fromMap(raw).toEntity());
      }
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> getCurrentUser() async {
    try {
      final (raw, userRole) = await service.getCurrentUser();

      if (userRole == "Jobseeker") {
        return Right(JobSeekerModel.fromMap(raw).toEntity());
      } else if (userRole == "Company") {
        return Right(CompanyModel.fromMap(raw).toEntity());
      } else {
        return Right(UnroleModel.fromMap(raw).toEntity());
      }
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<Either> signOut() async {
    try {
      final result = await service.signOut();
      return Right(result);
    } catch (e) {
      return Left(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}
