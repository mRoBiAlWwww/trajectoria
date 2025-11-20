import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class GetCompetitionsUseCase {
  final CompetitionRepository repository;
  GetCompetitionsUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getCompetitions();
  }
}
