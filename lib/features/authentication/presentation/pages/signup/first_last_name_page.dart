import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/helper/parser/capitalize.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/common/widgets/textfield/auth_text_field.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signup/photo_profile_page.dart';

class FirstLastNamePage extends StatefulWidget {
  final UserSignupReq signupReq;
  const FirstLastNamePage({super.key, required this.signupReq});

  @override
  State<FirstLastNamePage> createState() => _FirstLastNamePageState();
}

class _FirstLastNamePageState extends State<FirstLastNamePage> {
  final TextEditingController _firstnameCon = TextEditingController();
  final TextEditingController _lastnameCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstnameCon.addListener(_onTextChanged);
    _lastnameCon.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _firstnameCon.dispose();
    _lastnameCon.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid =
        _firstnameCon.text.trim().isNotEmpty &&
        _lastnameCon.text.trim().isNotEmpty;
    final double boxHeight = MediaQuery.of(context).viewInsets.bottom > 0
        ? 30.0
        : 275.0;

    return Scaffold(
      appBar: CustomAppBar(
        title: Center(
          child: FractionallySizedBox(
            widthFactor: 0.66,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        bottomLeft: Radius.circular(4.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 80, 25, 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.read<RoleCubit>().state == 'Jobseeker'
                    ? 'Masukkan nama lengkap'
                    : 'Masukkan nama penyelenggara',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              _firstnameField(context, _firstnameCon.text.trim().isNotEmpty),
              const SizedBox(height: 30),
              _lastnameField(context, _lastnameCon.text.trim().isNotEmpty),
              SizedBox(height: boxHeight),
              Align(
                alignment: Alignment.centerRight,
                child: _continueButton(context, isFormValid),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstnameField(BuildContext context, bool isFormValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nama depan :"),
        const SizedBox(height: 5),
        AppTextField(
          controller: _firstnameCon,
          hintText: 'kaesar',
          isFormValid: isFormValid,
          isPassword: false,
        ),
      ],
    );
  }

  Widget _lastnameField(BuildContext context, bool isFormValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nama belakang :"),
        const SizedBox(height: 5),
        AppTextField(
          controller: _lastnameCon,
          hintText: 'adam',
          isFormValid: isFormValid,
          isPassword: false,
        ),
      ],
    );
  }

  Widget _continueButton(BuildContext context, bool isFormValid) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.30,
      child: BasicAppButton(
        onPressed: isFormValid
            ? () {
                widget.signupReq.firstname = capitalizeWords(
                  _firstnameCon.text,
                );
                widget.signupReq.lastname = capitalizeWords(_lastnameCon.text);
                widget.signupReq.role = context.read<RoleCubit>().state;
                AppNavigator.push(
                  context,
                  PhotoProfilePage(signupReq: widget.signupReq),
                );
              }
            : null,
        backgroundColor: Colors.black,
        content: Text(
          'Lanjut',
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
