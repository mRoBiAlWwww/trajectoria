import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class GetCompetitionByTitleUseCase {
  final CompetitionRepository repository;
  GetCompetitionByTitleUseCase({required this.repository});

  Future<Either> call(String keyword) async {
    return await repository.getCompetitionsByTitle(keyword);
  }
}
