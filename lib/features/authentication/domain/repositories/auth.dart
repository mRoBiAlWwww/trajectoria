import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signin_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';

abstract class AuthRepository {
  Future<Either> signup(UserSignupReq user);
  Future<Either> resendVerificationEmail();
  Future<Either> additionalUserInfoJobSeeker(JobseekerSignupReq user);
  Future<Either> additionalUserInfoCompany(CompanySignupReq user);
  Future<Either> forgotPassword(String email);
  Future<Either> signin(UserSigninReq user);
  Future<Either> signInWithGoogle(String role);
  Future<Either> getCurrentUser();
  Future<Either> signOut();
}
