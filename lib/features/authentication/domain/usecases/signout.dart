import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.signOut();
  }
}
