import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getCurrentUser();
  }
}
