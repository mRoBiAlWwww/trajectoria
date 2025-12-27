import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/domain/entities/company_entity.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

class CreateCompetitionUseCase {
  final CompetitionOrganizerRepository repository;

  CreateCompetitionUseCase({required this.repository});

  Future<Either> call(CompetitionEntity newCompetition) async {
    final companyResult = await repository.getCurrentCompanyInformation();

    return companyResult.fold(
      (companyFailure) => Future.value(Left(companyFailure)),
      (companyData) async {
        final companyDataFinal = companyData as CompanyEntity;

        final CompetitionEntity newCompetitionFinal = newCompetition.copyWith(
          companyEmail: companyDataFinal.email,
          companyProfileImage: companyDataFinal.profileImage,
        );

        return await repository.createCompetition(newCompetitionFinal);
      },
    );
  }
}
