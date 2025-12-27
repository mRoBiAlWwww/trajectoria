import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/core/navigation/main_wrapper.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signup/welcome_animation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    context.read<AuthStateCubit>().appStarted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          AppNavigator.pushReplacement(context, WelcomeAnimationPage());
        }
        if (state is AuthSuccess) {
          AppNavigator.pushReplacement(context, MainWrapper());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            opacity: _opacity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(-10.0, 0.0),
                  child: Image.asset(AppImages.logo, width: 75, height: 150),
                ),
                SizedBox(height: 10),
                Text(
                  "trajectoria",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
