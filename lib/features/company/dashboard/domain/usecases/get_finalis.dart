import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetFinalisUseCase {
  final CreateCompetitionRepository repository;

  GetFinalisUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.getFinalis(competitionId);
  }
}
