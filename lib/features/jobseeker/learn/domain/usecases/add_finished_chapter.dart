import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class AddFinishedChapterStatusUseCase {
  final LearnRepository repository;
  AddFinishedChapterStatusUseCase({required this.repository});

  Future<Either> call(String chapterId) async {
    return await repository.addFinishedChapter(chapterId);
  }
}
