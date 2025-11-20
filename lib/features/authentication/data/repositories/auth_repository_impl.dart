import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:trajectoria/features/authentication/data/datasources/auth_firebase_service.dart';
import 'package:trajectoria/features/authentication/data/models/company.dart';
import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/unrole.dart';
import 'package:trajectoria/features/authentication/data/models/user_signin_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';
import 'package:trajectoria/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(UserSignupReq user) async {
    return await sl<AuthFirebaseService>().signup(user);
  }

  @override
  Future<Either> resendVerificationEmail() async {
    return await sl<AuthFirebaseService>().resendVerificationEmail();
  }

  @override
  Future<Either> additionalUserInfoJobSeeker(JobseekerSignupReq user) async {
    return await sl<AuthFirebaseService>().additionalUserInfoJobSeeker(user);
  }

  @override
  Future<Either> additionalUserInfoCompany(CompanySignupReq user) async {
    return await sl<AuthFirebaseService>().additionalUserInfoCompany(user);
  }

  @override
  Future<Either> forgotPassword(String email) async {
    return await sl<AuthFirebaseService>().forgotPassword(email);
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    var userData = await sl<AuthFirebaseService>().signin(user);
    return userData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        if (data[1] == "Jobseeker") {
          return Right(JobSeekerModel.fromMap(data[0]).toEntity());
        } else {
          return Right(CompanyModel.fromMap(data[0]).toEntity());
        }
        // return Right(UserModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> signInWithGoogle(String role) async {
    var user = await sl<AuthFirebaseService>().signInWithGoogle(role);
    return user.fold(
      (error) {
        return Left(error);
      },
      (data) {
        debugPrint("masalha");
        debugPrint(data[1]);
        if (data[1] == "Jobseeker") {
          return Right(JobSeekerModel.fromMap(data[0]).toEntity());
        } else if (data[1] == "Company") {
          return Right(CompanyModel.fromMap(data[0]).toEntity());
        } else {
          debugPrint("harus sini");
          return Right(UnroleModel.fromMap(data[0]).toEntity());
        }
        // return Right(UserModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> getCurrentUser() async {
    var user = await sl<AuthFirebaseService>().getCurrentUser();
    return user.fold(
      (error) {
        return Left(error);
      },
      (data) {
        if (data[1] == "Jobseeker") {
          return Right(JobSeekerModel.fromMap(data[0]).toEntity());
        } else if (data[1] == "Company") {
          return Right(CompanyModel.fromMap(data[0]).toEntity());
        } else {
          return Right(UnroleModel.fromMap(data[0]).toEntity());
        }
        // return Right(UserModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> signOut() async {
    return await sl<AuthFirebaseService>().signOut();
  }
}
