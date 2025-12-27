import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/company/dashboard/domain/entities/announcement.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';

class FinalAssessmentUseCase {
  final CompetitionOrganizerRepository repository;
  FinalAssessmentUseCase({required this.repository});

  Future<Either> call(
    int totalScore,
    String feedback,
    String submissionId,
    String companyName,
    String title,
    String competitionId,
    String userId,
  ) async {
    final announcement = AnnouncementEntity(
      companyName: companyName,
      competitionName: title,
      competitionId: competitionId,
      submissionId: submissionId,
      userId: userId,
      isRead: false,
    );
    return await repository.finalAssessment(
      totalScore,
      feedback,
      submissionId,
      announcement,
    );
  }
}
