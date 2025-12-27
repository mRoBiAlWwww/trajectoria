import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class DeleteBookmarkUseCase {
  final CompetitionRepository repository;
  DeleteBookmarkUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.deleteBookmark(competitionId);
  }
}
