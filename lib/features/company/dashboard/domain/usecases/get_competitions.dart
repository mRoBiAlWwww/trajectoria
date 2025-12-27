import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetCompetitionsByCurrentCompanyUseCase {
  final CompetitionOrganizerRepository repository;
  GetCompetitionsByCurrentCompanyUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getCompetitionsByCurrentCompany();
  }
}
