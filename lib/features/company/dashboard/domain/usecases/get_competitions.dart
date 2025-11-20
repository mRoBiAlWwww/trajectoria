import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetCompetitionsCompanyUseCase {
  final CreateCompetitionRepository repository;
  GetCompetitionsCompanyUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getCompetitions();
  }
}
