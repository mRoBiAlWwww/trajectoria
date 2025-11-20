import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetUserInfoUseCase {
  final CreateCompetitionRepository repository;
  GetUserInfoUseCase({required this.repository});

  Future<Either> call(String submissionId) async {
    return await repository.getUserInfo(submissionId);
  }
}
