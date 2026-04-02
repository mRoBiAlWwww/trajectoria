import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/toast/toast.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin/signin_page.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signup/first_last_name_page.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  final String purpose;
  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.purpose,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with TickerProviderStateMixin {
  Timer? _timer;
  final user = FirebaseAuth.instance.currentUser;

  late final AnimationController _bounceController;
  late final Animation<Offset> _bounceAnimation;

  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    // Bounce animation for the email icon
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<Offset>(
      begin: const Offset(0, -5),
      end: const Offset(0, 5),
    ).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Animated dots controller
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    if (widget.purpose == "register") {
      _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
        await FirebaseAuth.instance.currentUser!.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;
        if (updatedUser!.emailVerified) {
          _timer?.cancel();
          if (mounted) {
            AppNavigator.pushAndRemove(
              context,
              FirstLastNamePage(
                signupReq: UserSignupReq(email: updatedUser.email!),
              ),
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bounceController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthStateCubit(),
        child: BlocListener<AuthStateCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              context.showErrorToast(state.errorMessage);
            }
            if (state is AuthSuccess) {
              context.showSuccessToast(state.user.name);
            }
          },
          child: Builder(
            builder: (newContext) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 75,
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              AppVectors.back,
                              width: 40.0,
                              height: 40.0,
                            ),
                          ),
                          SizedBox(height: 70),
                          AnimatedBuilder(
                            animation: _bounceAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  -30.0,
                                  _bounceAnimation.value.dy,
                                ),
                                child: child,
                              );
                            },
                            child: Image.asset(
                              AppImages.gradientEmail,
                              width: 120,
                              height: 60,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Cek Emailmu!",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.purpose == "register"
                                      ? 'Verifikasi terkirim ke '
                                      : 'konfirmasi setel ulang password terkirim ke ',
                                ),

                                TextSpan(
                                  text: widget.email,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                TextSpan(
                                  text: widget.purpose == "register"
                                      ? ' Periksa '
                                      : '. Jangan lupa periksa ',
                                ),

                                const TextSpan(
                                  text: 'kotak masuk',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(text: ' atau folder '),

                                const TextSpan(
                                  text: 'spam',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                TextSpan(
                                  text: widget.purpose == "register"
                                      ? ' untuk menerima tautan setel ulang password akun mu'
                                      : ' ya!',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (widget.purpose == "register") ...[
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _dotsController,
                          builder: (context, _) {
                            final dotCount =
                                (_dotsController.value * 3).floor() + 1;
                            final dots = '.' * dotCount;
                            return Text(
                              'Memverifikasi$dots',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ],
                      SizedBox(height: 100),
                      Text(
                        "Email tidak masuk?",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: widget.purpose == "register"
                            ? () async {
                                await newContext
                                    .read<AuthStateCubit>()
                                    .resendVerificationEmail();
                              }
                            : () async {
                                await newContext
                                    .read<AuthStateCubit>()
                                    .forgotPassword(widget.email);
                              },
                        child: Text(
                          widget.purpose == "register"
                              ? "Kirim ulang kode verifikasi"
                              : "Kirim lagi tautan setel ulang password",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (widget.purpose == "forgot")
                        TextButton(
                          onPressed: () {
                            AppNavigator.push(context, SigninPage());
                          },
                          child: Text(
                            "Kembali ke halaman login",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
