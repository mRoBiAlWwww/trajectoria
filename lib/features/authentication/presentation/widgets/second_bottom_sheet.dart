import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/helper/overlay/overlay.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/navigation/main_wrapper.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/google_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/choose_role_page.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin/signin_page.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signup/signup_page.dart';

class SecondSingupSheetContent extends StatefulWidget {
  final String methode;
  const SecondSingupSheetContent({super.key, required this.methode});

  @override
  State<SecondSingupSheetContent> createState() =>
      _SecondSingupSheetContentState();
}

class _SecondSingupSheetContentState extends State<SecondSingupSheetContent> {
  bool platform = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          GlobalLoading.show(context);
        } else {
          GlobalLoading.hide();
        }
        if (state is AuthSuccess) {
          //Hanya untuk handle login/register google
          if (platform && widget.methode == "masuk") {
            state.user.role == "Unrole"
                ? AppNavigator.pushReplacement(
                    context,
                    ChooseRolePage(from: "authenticated"),
                  )
                : AppNavigator.pushReplacement(context, MainWrapper());
          } else if (platform && widget.methode == "daftar") {
            AppNavigator.pushReplacement(context, MainWrapper());
          }
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(20, 10, 10, 20),
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 30),
                  Image.asset(AppImages.profile, width: 65, height: 65),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "Mau lanjut pakai apa nih?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  _emailButton(),
                  SizedBox(height: 10),
                  _googleButton(),
                  SizedBox(height: 30),
                ],
              ),
              Align(
                alignment: AlignmentGeometry.topRight,
                child: IconButton(
                  icon: SvgPicture.asset(
                    AppVectors.close,
                    width: 40.0,
                    height: 40.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailButton() {
    return Builder(
      builder: (context) {
        return BasicAppButton(
          onPressed: () {
            Navigator.pop(context);
            widget.methode == "daftar"
                ? AppNavigator.push(context, SignupPage())
                : AppNavigator.push(context, SigninPage());
          },
          backgroundColor: Colors.white,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.email, width: 25, height: 25),
              SizedBox(width: 10),
              Text(
                "Lanjut dengan Email",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          isBordered: true,
          borderColor: const Color.fromARGB(255, 246, 234, 234),
        );
      },
    );
  }

  Widget _googleButton() {
    return Builder(
      builder: (context) {
        return BasicAppButton(
          isBordered: true,
          onPressed: () async {
            context.read<LoginFlowCubit>().setGooglePopupFlow(true);
            platform = true;
            await context.read<AuthStateCubit>().googleSignin(
              context.read<RoleCubit>().state.isNotEmpty
                  ? context.read<RoleCubit>().state
                  : "Unrole",
            );

            // if (context.mounted) {
            //   // Navigator.pop(context);
            //   AppNavigator.pushReplacement(context,  MainWrapper());
            // }
          },
          backgroundColor: Colors.white,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.google, width: 25, height: 25),
              SizedBox(width: 10),
              Text(
                "Lanjut dengan Google",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          borderColor: const Color.fromARGB(255, 246, 234, 234),
        );
      },
    );
  }
}
