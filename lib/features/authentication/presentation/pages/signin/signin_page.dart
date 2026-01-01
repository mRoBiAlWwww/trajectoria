import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/common/widgets/textfield/auth_text_field.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/navigation/main_wrapper.dart';
import 'package:trajectoria/features/authentication/data/models/user_signin_req.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin/forgot_password_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailCon.addListener(_onTextChanged);
    _passwordCon.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _emailCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid =
        _emailCon.text.trim().isNotEmpty && _passwordCon.text.trim().isNotEmpty;
    final double boxHeight = MediaQuery.of(context).viewInsets.bottom > 0
        ? 10.0
        : 200.0;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 30.0,
              icon: SvgPicture.asset(
                AppVectors.close,
                width: 40.0,
                height: 40.0,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<AuthStateCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppNavigator.push(context, MainWrapper());
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alamat Email',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Masukin Email dan kata sandi buat lanjut.',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 60),
                _emailField(_emailCon.text.trim().isNotEmpty),
                const SizedBox(height: 20),
                _passwordField(_passwordCon.text.trim().isNotEmpty),
                const SizedBox(height: 10),
                BlocBuilder<AuthStateCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthFailure) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 10),
                boxHeight == 10.0
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: AlignmentGeometry.centerRight,
                        child: _forgotPassword(),
                      ),
                SizedBox(height: boxHeight),
                _continueButton(isFormValid),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {
        AppNavigator.push(context, ForgotPasswordPage());
      },
      style: TextButton.styleFrom(foregroundColor: Colors.black),
      child: Text(
        "Lupa kata sandi",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  Widget _emailField(bool isFormValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email Kamu :"),
        const SizedBox(height: 5),
        AppTextField(
          controller: _emailCon,
          hintText: 'nama@email.com',
          isFormValid: isFormValid,
          isPassword: false,
        ),
      ],
    );
  }

  Widget _passwordField(bool isFormValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Kata Sandi :"),
        const SizedBox(height: 5),
        AppTextField(
          controller: _passwordCon,
          hintText: 'Password',
          isFormValid: isFormValid,
          isPassword: true,
        ),
      ],
    );
  }

  Widget _continueButton(bool isFormValid) {
    return BlocBuilder<AuthStateCubit, AuthState>(
      builder: (context, state) {
        Widget? buttonContent;

        if (state is AuthInitial) {
          buttonContent = const Text(
            "Lanjut",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          );
        }
        if (state is AuthLoading) {
          buttonContent = const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          );
        }
        return BasicAppButton(
          onPressed: isFormValid
              ? () {
                  context.read<AuthStateCubit>().signin(
                    UserSigninReq(
                      email: _emailCon.text,
                      password: _passwordCon.text,
                    ),
                  );
                }
              : null,
          backgroundColor: Colors.black,
          content:
              buttonContent ??
              Text(
                "Lanjut",
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                ),
              ),
        );
      },
    );
  }
}
