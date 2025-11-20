import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';

class UpploadFileUseCase {
  final CompetitionRepository repository;
  UpploadFileUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.uploadMultiplePdfs();
  }
}
