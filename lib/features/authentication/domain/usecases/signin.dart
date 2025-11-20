import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/user_signin_req.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class SigninUseCase {
  final AuthRepository repository;

  SigninUseCase({required this.repository});

  Future<Either> call(UserSigninReq? user) async {
    return await repository.signin(user!);
  }
}
