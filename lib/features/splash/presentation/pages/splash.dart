import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/core/navigation/main_wrapper.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/common/helper/navigator/page_transitions.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signup/welcome_animation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    // Logo: scale + fade in (0–800ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    // Text: fade in (400–1000ms)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Dots: loop
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _dotsController.repeat();

    context.read<AuthStateCubit>().appStarted();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.pushReplacement(
            context,
            HeroFadeRoute(page: const WelcomeAnimationPage()),
          );
        }
        if (state is AuthSuccess) {
          AppNavigator.pushReplacement(context, const MainWrapper());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    ),
                  );
                },
                child: Hero(
                  tag: 'app_logo',
                  child: Transform.translate(
                    offset: const Offset(-10.0, 0.0),
                    child: Image.asset(AppImages.logo, width: 75, height: 150),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Animated text
              FadeTransition(
                opacity: _textOpacity,
                child: Hero(
                  tag: 'app_title',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      "trajectoria",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Loading dots
              AnimatedBuilder(
                animation: _dotsController,
                builder: (context, _) {
                  return FadeTransition(
                    opacity: _textOpacity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        // Each dot pulses at a different phase
                        final delay = i * 0.33;
                        final t = (_dotsController.value + delay) % 1.0;
                        final opacity = (1.0 - (t * 2 - 1).abs()).clamp(0.3, 1.0);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: opacity),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
