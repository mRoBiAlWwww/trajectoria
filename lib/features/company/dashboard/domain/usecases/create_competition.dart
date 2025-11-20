import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

class CreateCompetitionUseCase {
  final CreateCompetitionRepository repository;

  CreateCompetitionUseCase({required this.repository});

  Future<Either> call(CompetitionEntity newCompetition) async {
    return await repository.createCompetition(newCompetition);
  }
}
