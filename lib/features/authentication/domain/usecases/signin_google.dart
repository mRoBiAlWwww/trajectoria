import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase({required this.repository});

  Future<Either> call(String role) async {
    return await repository.signInWithGoogle(role);
  }
}
