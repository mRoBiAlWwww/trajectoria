import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class GetUserInformationUseCase {
  final CompetitionOrganizerRepository repository;
  GetUserInformationUseCase({required this.repository});

  Future<Either> call(String userId) async {
    return await repository.getUserInformationById(userId);
  }
}
