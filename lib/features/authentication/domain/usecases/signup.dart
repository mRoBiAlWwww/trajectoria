import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase({required this.repository});

  Future<Either> call(UserSignupReq? user) async {
    return await repository.signup(user!);
  }
}
