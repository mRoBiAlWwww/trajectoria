import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class DeleteFinalisUseCase {
  final CompetitionOrganizerRepository repository;

  DeleteFinalisUseCase({required this.repository});

  Future<Either> call(String finalisId) async {
    return await repository.deleteFinalis(finalisId);
  }
}
