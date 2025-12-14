import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';

class AddOnprogresChapterCubit {
  final LearnRepository repository;
  AddOnprogresChapterCubit({required this.repository});

  Future<Either> call(String chapterId) async {
    return await repository.addOnprogresChapter(chapterId);
  }
}
