import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/helper/overlay/overlay.dart';
import 'package:trajectoria/core/navigation/company_wrapper.dart';
import 'package:trajectoria/core/navigation/jobseeker_wrapper.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin_or_signup_page.dart';
import 'package:trajectoria/core/services/notification_service.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          GlobalLoading.show(context);
        } else {
          GlobalLoading.hide();
        }
      },
      child: BlocBuilder<AuthStateCubit, AuthState>(
        builder: (context, state) {
          debugPrint("=== BUILD TRIGGERED ===");
          debugPrint("Current AuthState: $state");

          if (state is AuthSuccess) {
            final user = state.user;
            NotificationService.instance.saveTokenToDatabase();

            if (user.role == "Jobseeker") {
              return JobseekerWrapper();
            } else if (user.role == "Company") {
              return CompanyWrapper();
            }
            return const SizedBox.shrink();
          }

          return SigninOrSignupPage();
        },
      ),
    );
  }
}

// class MainWrapper extends StatelessWidget {
//   const MainWrapper({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final authState = context.watch<AuthStateCubit>().state;

//     debugPrint("=== BUILD TRIGGERED ===");
//     debugPrint("Current AuthState: $authState");

//     if (authState is AuthSuccess) {
//       final user = authState.user;
//       debugPrint("auth");
//       debugPrint(user.role);

//       if (user.role == "Jobseeker") {
//         return JobseekerWrapper();
//       } else if (user.role == "Company") {
//         debugPrint("melbu kene loh");
//         return CompanyWrapper();
//       }
//       return SizedBox.shrink();
//     } else {
//       return SigninOrSignupPage();
//     }
//   }
// }
