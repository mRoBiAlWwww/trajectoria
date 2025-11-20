import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class GetCompetitionByFiltersUseCase {
  final CompetitionRepository repository;
  GetCompetitionByFiltersUseCase({required this.repository});

  Future<Either> call(List<String> category, String duration) async {
    return await repository.getCompetitionsByFilters(category, duration);
  }
}
