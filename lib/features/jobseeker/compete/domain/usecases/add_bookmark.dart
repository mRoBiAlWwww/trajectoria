import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class AddBookmarkUseCase {
  final CompetitionRepository repository;
  AddBookmarkUseCase({required this.repository});

  Future<Either> call(String competitionId) async {
    return await repository.addBookmark(competitionId);
  }
}
