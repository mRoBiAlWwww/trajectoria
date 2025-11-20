import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class DeleteCompetitionByIdUseCase {
  final CreateCompetitionRepository repository;

  DeleteCompetitionByIdUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.deleteCompetitionById(competitionId);
  }
}
