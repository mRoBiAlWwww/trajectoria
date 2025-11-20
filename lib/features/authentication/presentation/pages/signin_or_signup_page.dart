import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/choose_role_page.dart';
import 'package:trajectoria/features/authentication/presentation/widgets/gif.dart';
import 'package:trajectoria/features/authentication/presentation/widgets/second_bottom_sheet.dart';

class SigninOrSignupPage extends StatelessWidget {
  const SigninOrSignupPage({super.key});

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
                SvgPicture.asset(
                  AppVectors.logo,
                  width: 100.0,
                  height: 50.0,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                SizedBox(height: 500, width: 500, child: GifSlideshow()),
              ],
            ),
            Column(
              children: [
                _singupButton(context),
                SizedBox(height: 10),
                _singinButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _singinButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        AppBottomsheet.display(
          context,
          // const SecondSingupSheetContent(methode: "masuk"),
          BlocProvider.value(
            value: context.read<AuthStateCubit>(),
            child: const SecondSingupSheetContent(methode: "masuk"),
          ),
        );
      },
      backgroundColor: AppColors.secondaryBackgroundButton,
      content: Text(
        "Masuk",
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _singupButton(BuildContext context) {
    return BasicAppButton(
      // isBordered: true,
      onPressed: () {
        AppNavigator.push(
          context,
          ChooseRolePage(),
          // BlocProvider.value(
          //   value: context.read<AuthStateCubit>(),
          //   child: ChooseRolePage(),
          // ),
        );
      },
      backgroundColor: Colors.white,
      content: Text(
        "Daftar",
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

//  Widget _singinButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//       ),
//       child: Text(
//         'Sign In',
//         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//   Widget _singupButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         AppBottomsheet.display(context, const FirstSingupSheetContent());
//       },
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//           side: const BorderSide(
//             color: Colors.black,
//             width: 2.0,
//             style: BorderStyle.solid,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       child: Text(
//         'Sign Up',
//         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
