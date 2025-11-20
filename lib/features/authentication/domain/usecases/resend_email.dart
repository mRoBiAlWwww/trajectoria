import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class ResendEmailUseCase {
  final AuthRepository repository;
  ResendEmailUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.resendVerificationEmail();
  }
}
