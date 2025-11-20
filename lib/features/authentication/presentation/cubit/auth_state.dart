import 'package:trajectoria/features/authentication/domain/entities/company_entity.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/authentication/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);

  bool get isJobSeeker => user is JobSeekerEntity;
  bool get isCompany => user is CompanyEntity;

  JobSeekerEntity? get jobSeeker =>
      user is JobSeekerEntity ? user as JobSeekerEntity : null;

  CompanyEntity? get company =>
      user is CompanyEntity ? user as CompanyEntity : null;
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}

class AuthUserLoaded extends AuthState {
  final UserEntity user;
  AuthUserLoaded(this.user);

  bool get isJobSeeker => user is JobSeekerEntity;
  bool get isCompany => user is CompanyEntity;
}

class UnAuthenticated extends AuthState {}
