import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class AddTokenNotificationUseCase {
  final AuthRepository repository;
  AddTokenNotificationUseCase({required this.repository});

  Future<Either> call(String tokenId) async {
    return await repository.addTokenNotification(tokenId);
  }
}
