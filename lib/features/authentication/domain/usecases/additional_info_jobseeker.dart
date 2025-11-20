import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class AdditionalInfoJobseekerUseCase {
  final AuthRepository repository;
  AdditionalInfoJobseekerUseCase({required this.repository});

  Future<Either> call(JobseekerSignupReq? user) async {
    return await repository.additionalUserInfoJobSeeker(user!);
  }
}
