import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signin_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:trajectoria/features/authentication/domain/usecases/additional_info_company.dart';
import 'package:trajectoria/features/authentication/domain/usecases/additional_info_jobseeker.dart';
import 'package:trajectoria/features/authentication/domain/usecases/forgot_password.dart';
import 'package:trajectoria/features/authentication/domain/usecases/get_current_user.dart';
import 'package:trajectoria/features/authentication/domain/usecases/resend_email.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signin.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signin_google.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signout.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signup.dart';
import 'package:trajectoria/service_locator.dart';
import 'auth_state.dart';

class AuthStateCubit extends Cubit<AuthState> {
  AuthStateCubit() : super(AuthInitial());

  Future<void> appStarted() async {
    await Future.delayed(const Duration(seconds: 2));

    var result = await sl<GetCurrentUserUseCase>().call();

    result.fold(
      (failure) {
        if (failure == 'Unauthenticated') {
          emit(UnAuthenticated());
        } else {
          emit(AuthFailure(failure));
        }
      },
      (data) {
        emit(AuthSuccess(data));
      },
    );
  }

  Future<String> signup(UserSignupReq user) async {
    emit(AuthLoading());
    final result = await sl<SignupUseCase>().call(user);
    // final usecase = sl<SignupUseCase>();
    // final result = await usecase(user);

    final String isSuccess = result.fold(
      (failure) {
        emit(AuthFailure(failure));
        return failure;
      },
      (successMessage) {
        if (user.role == "Jobseeker") {
          emit(AuthSuccess(user.toJobseekerEntity()));
        } else {
          emit(AuthSuccess(user.toCompanyEntity()));
        }
        return successMessage.toString();
      },
    );

    return (isSuccess);
  }

  Future<void> signin(UserSigninReq user) async {
    emit(AuthLoading());
    final result = await sl<SigninUseCase>().call(user);
    // final usecase = sl<SigninUseCase>();
    // final result = await usecase(user);

    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (data) => emit(AuthSuccess(data)),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    final result = await sl<ForgotPasswordUseCase>().call(email);
    // final usecase = sl<ForgotPasswordUseCase>();
    // final result = await usecase(email);
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (successMessage) => emit(AuthSuccess(successMessage)),
    );
  }

  Future<void> resendVerificationEmail() async {
    emit(AuthLoading());
    final result = await sl<ResendEmailUseCase>().call();
    // final usecase = sl<ResendEmailUseCase>();
    // final result = await usecase();
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (successMessage) => emit(AuthSuccess(successMessage)),
    );
  }

  Future<void> additionalUserInfoJobSeeker(JobseekerSignupReq user) async {
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 2));
    final result = await sl<AdditionalInfoJobseekerUseCase>().call(user);
    // final usecase = sl<AdditionalInfoUseCase>();
    // final result = await usecase(user);
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (successMessage) => emit(AuthSuccess(user.toJobseekerEntity())),
    );
  }

  Future<void> additionalUserInfoCompany(CompanySignupReq user) async {
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 2));
    final result = await sl<AdditionalInfoCompanyUseCase>().call(user);
    // final usecase = sl<AdditionalInfoUseCase>();
    // final result = await usecase(user);
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (successMessage) => emit(AuthSuccess(user.toCompanyEntity())),
    );
  }

  Future<void> googleSignin(String role) async {
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 2));
    final result = await sl<SignInWithGoogleUseCase>().call(role);
    // final usecase = sl<SignInWithGoogleUseCase>();
    // final result = await usecase(role);

    // if (isClosed) return;

    result.fold(
      (failure) {
        // if (!isClosed)
        emit(AuthFailure(failure));
      },
      (data) {
        // if (!isClosed)
        emit(AuthSuccess(data));
      },
    );
  }

  Future<Either> getCurrentUser() async {
    final result = await sl<GetCurrentUserUseCase>().call();
    return result;
  }

  Future<void> signout() async {
    emit(AuthLoading());
    final result = await sl<SignOutUseCase>().call();
    result.fold(
      (failure) {
        emit(AuthFailure(failure));
      },
      (data) {
        emit(UnAuthenticated());
      },
    );
  }

  void reset() {
    emit(AuthInitial());
  }
}

  // Future<Either> getCurrentUser(String role) async {
  //   emit(AuthLoading());
  //   final Either result;
  //   if (role == "jobseeker") {
  //     final usecase = sl<GetJobseekerUseCase>();
  //     result = await usecase();
  //   } else {
  //     final usecase = sl<GetCompanyUseCase>();
  //     result = await usecase();
  //   }
  //   return result;
  // }