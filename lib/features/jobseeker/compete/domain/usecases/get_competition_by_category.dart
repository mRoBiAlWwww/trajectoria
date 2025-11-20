import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class GetCompetitionByCategoryUseCase {
  final CompetitionRepository repository;
  GetCompetitionByCategoryUseCase({required this.repository});

  Future<Either> call(String categoryId) async {
    return await repository.getCompetitionsByCategory(categoryId);
  }
}
