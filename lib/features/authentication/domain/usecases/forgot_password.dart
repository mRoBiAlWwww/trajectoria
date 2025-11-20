import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase({required this.repository});

  Future<Either> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
