import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class DownloadFileUseCase {
  final CompetitionRepository repository;
  DownloadFileUseCase({required this.repository});

  Future<Either> call(String fileUrl, String fileName) async {
    return await repository.downloadAndOpenFile(fileUrl, fileName);
  }
}
