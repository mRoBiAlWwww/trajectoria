import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/common/widgets/textField/auth_text_field.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/email_verification_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
        ? 40.0
        : 275.0;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
      body: BlocProvider(
        create: (context) => AuthStateCubit(),
        child: BlocListener<AuthStateCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              AppNavigator.push(
                context,
                EmailVerificationPage(
                  email: _emailCon.text,
                  purpose: "register",
                ),
              );
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
                    'Kami akan kirim link verifikasi ke email kamu. Masukin Email dan kata sandi buat lanjut.',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 60),
                  _emailField(_emailCon.text.trim().isNotEmpty),
                  const SizedBox(height: 20),
                  _passwordField(_passwordCon.text.trim().isNotEmpty),
                  SizedBox(height: 10),
                  BlocBuilder<AuthStateCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthFailure) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5),
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
                  SizedBox(height: boxHeight),
                  _continueButton(isFormValid),
                  SizedBox(height: 10),
                ],
              ),
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
                  final authCubit = context.read<AuthStateCubit>();
                  final role = context.read<RoleCubit>().state;
                  String result = await authCubit.signup(
                    UserSignupReq(
                      email: _emailCon.text,
                      password: _passwordCon.text,
                    ),
                  );
                  debugPrint(result);
                  if (result == "true") {
                    final user = UserSignupReq(
                      email: _emailCon.text,
                      password: _passwordCon.text,
                      role: role,
                    );

                    if (role == "Jobseeker") {
                      await authCubit.additionalUserInfoJobSeeker(
                        user.toJobseekerSignupReq(),
                      );
                    } else {
                      await authCubit.additionalUserInfoCompany(
                        user.toCompanySignupReq(),
                      );
                    }
                  }
                  // result == "true"
                  //     ? await authCubit.additionalUserInfo(
                  //         UserSignupReq(
                  //           email: _emailCon.text,
                  //           password: _passwordCon.text,
                  //           role: role,
                  //         ).toEntity(),
                  //       )
                  //     : null;
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


// TextField(
        //   controller: _emailCon,
        //   decoration: InputDecoration(
        //     hintText: 'nama@email.com',
        //     enabledBorder: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         width: 2.0,
        //         color: isFormValid ? Colors.black : Colors.grey,
        //       ),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         width: 2.0,
        //         color: isFormValid ? Colors.black : Colors.grey,
        //       ),
        //     ),
        //   ),
        // ),
         // TextField(
        //   controller: _passwordCon,
        //   decoration: InputDecoration(
        //     hintText: 'Password',
        //     enabledBorder: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         width: 2.0,
        //         color: isFormValid ? Colors.black : Colors.grey,
        //       ),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         width: 2.0,
        //         color: isFormValid ? Colors.black : Colors.grey,
        //       ),
        //     ),
        //   ),
        // ),
// Widget _continueButton(BuildContext context, bool isFormValid) {
  //   return ElevatedButton(
  //     onPressed: isFormValid
  //         ? () {
  //             AppNavigator.push(
  //               context,
  //               FirstLastNamePage(
  //                 signinReq: UserSigninReq(
  //                   email: _emailCon.text,
  //                   password: _passwordCon.text,
  //                   role: context.read<RoleCubit>().state,
  //                 ),
  //               ),
  //             );
  //           }
  //         : null,
  //     style: ElevatedButton.styleFrom(
  //       minimumSize: const Size(double.infinity, 50),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  //       backgroundColor: isFormValid ? Colors.black : Colors.grey,
  //       foregroundColor: isFormValid
  //           ? Colors.white
  //           : AppColors.disableTextButton,
  //     ),
  //     child: Text(
  //       'Lanjut',
  //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }