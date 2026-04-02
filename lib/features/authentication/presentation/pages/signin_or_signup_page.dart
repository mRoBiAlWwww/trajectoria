import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/animation/animated_press_button.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/choose_role_page.dart';
import 'package:trajectoria/features/authentication/presentation/widgets/gif.dart';
import 'package:trajectoria/features/authentication/presentation/widgets/second_bottom_sheet.dart';

class SigninOrSignupPage extends StatefulWidget {
  const SigninOrSignupPage({super.key});

  @override
  State<SigninOrSignupPage> createState() => _SigninOrSignupPageState();
}

class _SigninOrSignupPageState extends State<SigninOrSignupPage>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _floatController;
  late Animation<double> _btn1Opacity;
  late Animation<double> _btn2Opacity;
  late Animation<Offset> _btn1Slide;
  late Animation<Offset> _btn2Slide;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Staggered button entrance
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _btn1Opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _btn1Slide = Tween(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _btn2Opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _btn2Slide = Tween(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    // Subtle floating logo
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _floatAnimation = Tween(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _floatController.repeat(reverse: true);

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: child,
                    );
                  },
                  child: SvgPicture.asset(
                    AppVectors.logo,
                    width: 100.0,
                    height: 50.0,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(height: 500, width: 500, child: GifSlideshow()),
              ],
            ),
            AnimatedBuilder(
              animation: _entranceController,
              builder: (context, _) {
                return Column(
                  children: [
                    Transform.translate(
                      offset: _btn1Slide.value,
                      child: Opacity(
                        opacity: _btn1Opacity.value,
                        child: _signupButton(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Transform.translate(
                      offset: _btn2Slide.value,
                      child: Opacity(
                        opacity: _btn2Opacity.value,
                        child: _signinButton(context),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _signinButton(BuildContext context) {
    return AnimatedPressButton(
      onPressed: () {
        AppBottomsheet.display(
          context,
          BlocProvider.value(
            value: context.read<AuthStateCubit>(),
            child: const SecondSingupSheetContent(methode: "masuk"),
          ),
        );
      },
      child: BasicAppButton(
        onPressed: () {
          AppBottomsheet.display(
            context,
            BlocProvider.value(
              value: context.read<AuthStateCubit>(),
              child: const SecondSingupSheetContent(methode: "masuk"),
            ),
          );
        },
        backgroundColor: AppColors.secondaryBackgroundButton,
        content: const Text(
          "Masuk",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _signupButton(BuildContext context) {
    return AnimatedPressButton(
      onPressed: () {
        AppNavigator.push(context, const ChooseRolePage());
      },
      child: BasicAppButton(
        onPressed: () {
          AppNavigator.push(context, const ChooseRolePage());
        },
        backgroundColor: Colors.white,
        content: const Text(
          "Daftar",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
