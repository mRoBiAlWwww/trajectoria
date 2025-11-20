import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/navigation/company_wrapper.dart';
import 'package:trajectoria/common/widgets/navigation/jobseeker_wrapper.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin_or_signup_page.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthStateCubit>().state;

    debugPrint("=== BUILD TRIGGERED ===");
    debugPrint("Current AuthState: $authState");

    if (authState is AuthSuccess) {
      final user = authState.user;
      debugPrint("auth");
      debugPrint(user.role);

      if (user.role == "Jobseeker") {
        return JobseekerWrapper();
      } else if (user.role == "Company") {
        debugPrint("melbu kene loh");
        return CompanyWrapper();
      }
      return SizedBox.shrink();
    } else {
      return SigninOrSignupPage();
    }
  }
}
