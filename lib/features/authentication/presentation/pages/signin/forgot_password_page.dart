import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/common/widgets/textfield/auth_text_field.dart';
import 'package:trajectoria/common/widgets/toast/toast.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/pages/email_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailCon.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _emailCon.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _emailCon.text.trim().isNotEmpty;
    final double boxHeight = MediaQuery.of(context).viewInsets.bottom > 0
        ? 50.0
        : 350.0;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                AppVectors.close,
                width: 40.0,
                height: 40.0,
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => AuthStateCubit(),
        child: BlocListener<AuthStateCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              context.showErrorToast(state.errorMessage);
            }
            if (state is AuthSuccess) {
              AppNavigator.push(
                context,
                EmailVerificationPage(email: _emailCon.text, purpose: "forgot"),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lupa Kata Sandimu?',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Masukkan email untuk menyetel ulang kata sandimu. Konfirmasi lewat email, lalu setel ulang setelahnya.',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 60),
                _emailField(_emailCon.text.trim().isNotEmpty),
                SizedBox(height: boxHeight),
                _continueButton(isFormValid),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField(bool isFormValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email Kamu :"),
        const SizedBox(height: 10),
        AppTextField(
          controller: _emailCon,
          hintText: 'nama@email.com',
          isFormValid: isFormValid,
          isPassword: false,
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              ? () async {
                  await context.read<AuthStateCubit>().forgotPassword(
                    _emailCon.text,
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
