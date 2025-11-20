import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';

class DeleteFinalisUseCase {
  final CreateCompetitionRepository repository;

  DeleteFinalisUseCase({required this.repository});

  Future<Either> call(String finalisId) async {
    return await repository.deleteFinalis(finalisId);
  }
}
