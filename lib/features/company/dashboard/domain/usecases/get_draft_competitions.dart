import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class GetDraftCompetitionsUseCase {
  final CreateCompetitionRepository repository;

  GetDraftCompetitionsUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getDraftCompetitions();
  }
}
