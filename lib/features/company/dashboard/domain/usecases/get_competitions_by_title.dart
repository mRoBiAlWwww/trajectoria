import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetCompetitionByKeywordCompanyUseCase {
  final CreateCompetitionRepository repository;
  GetCompetitionByKeywordCompanyUseCase({required this.repository});

  Future<Either> call(String keyword) async {
    return await repository.getCompetitionsByTitle(keyword);
  }
}
