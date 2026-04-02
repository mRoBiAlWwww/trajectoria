import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/repositories/profile.dart';

class GetMyCertificatesUseCase {
  final ProfileRepository repository;
  GetMyCertificatesUseCase({required this.repository});

  Future<Either> call() async {
    return await repository.getMyCertificates();
  }
}
