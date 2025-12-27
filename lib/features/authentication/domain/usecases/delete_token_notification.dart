import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class DeleteTokenNotificationUseCase {
  final AuthRepository repository;

  DeleteTokenNotificationUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.deleteTokenNotification();
  }
}
