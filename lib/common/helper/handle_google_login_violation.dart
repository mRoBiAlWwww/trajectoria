import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/authentication/domain/entities/unrole_entity.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';

Future<void> handleGoogleLoginViolation(
  BuildContext context,
  String role,
) async {
  debugPrint(role);
  final authCubit = context.read<AuthStateCubit>();

  final eitherUser = await authCubit.getCurrentUser();
  final UnroleEntity user = eitherUser.getOrElse(() => null);
  if (role == "Jobseeker") {
    await authCubit.additionalUserInfoJobSeeker(user.toJobseekerSignupReq());
  } else {
    await authCubit.additionalUserInfoCompany(user.toCompanySignupReq());
  }
}
