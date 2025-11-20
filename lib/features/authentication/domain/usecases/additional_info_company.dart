import 'package:dartz/dartz.dart';
import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';

class AdditionalInfoCompanyUseCase {
  final AuthRepository repository;
  AdditionalInfoCompanyUseCase({required this.repository});

  Future<Either> call(CompanySignupReq? user) async {
    return await repository.additionalUserInfoCompany(user!);
  }
}
