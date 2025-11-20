import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class GetCategoriesUseCase {
  final CompetitionRepository repository;
  GetCategoriesUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getCategories();
  }
}
