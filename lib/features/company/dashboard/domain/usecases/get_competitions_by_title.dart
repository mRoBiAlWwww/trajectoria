import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetCompetitionByKeywordCompanyUseCase {
  final CompetitionOrganizerRepository repository;
  GetCompetitionByKeywordCompanyUseCase({required this.repository});

  Future<Either> call(String keyword) async {
    return await repository.getCompetitionsByTitle(keyword);
  }
}
