import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetCompetitionByIdCompanyUseCase {
  final CreateCompetitionRepository repository;
  GetCompetitionByIdCompanyUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getCompetitionById(competitionId);
  }
}
