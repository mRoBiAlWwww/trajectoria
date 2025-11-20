import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/helper/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/helper/handle_google_login_violation.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/common/widgets/navigation/main_wrapper.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/widgets/first_bottom_sheet.dart';

class ChooseRolePage extends StatelessWidget {
  final String from;
  const ChooseRolePage({super.key, this.from = "notAuthenticated"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(AppImages.logoWhite, width: 50.0, height: 100.0),
                SizedBox(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kamu di tim mana?",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Britanica',
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Mau ikut kompetisi atau bikin kompetisi?",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Averia',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 50),
                    BlocBuilder<RoleCubit, String>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            _buildRoleCard(
                              imagePath: AppImages.jobseeker,
                              activeGradientColors: [
                                Colors.red.shade600,
                                Colors.red.shade900,
                              ],
                              activeGlowColor: const Color.fromRGBO(
                                255,
                                255,
                                255,
                                0.3,
                              ),
                              isSelected: state == "Jobseeker",
                              onTap: () {
                                context.read<RoleCubit>().setRole("Jobseeker");
                              },
                              text: 'Ikuti kompetisi, asah skill, raih peluang',
                            ),

                            const SizedBox(width: 10),

                            _buildRoleCard(
                              imagePath: AppImages.company,
                              activeGradientColors: [
                                Colors.blue.shade600,
                                Colors.blue.shade900,
                              ],
                              activeGlowColor: const Color.fromRGBO(
                                255,
                                255,
                                255,
                                0.3,
                              ),
                              isSelected: state == "Company",
                              onTap: () {
                                context.read<RoleCubit>().setRole("Company");
                              },
                              text: 'Buat kompetisi, temukan talenta terbaik',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            _continueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String imagePath,
    required List<Color> activeGradientColors,
    required Color activeGlowColor,
    required bool isSelected,
    required VoidCallback onTap,
    required String text,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: activeGradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,

            borderRadius: BorderRadius.circular(15.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeGlowColor,
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, width: 140, height: 140),
                SizedBox(height: 15),
                isSelected
                    ? Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'Britanica',
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BlocBuilder<RoleCubit, String>(
      builder: (context, state) {
        return BasicAppButton(
          onPressed: (state.isEmpty && from == "notAuthenticated")
              ? null
              : () {
                  if (state.isNotEmpty) {
                    if (from == "authenticated") {
                      debugPrint("yopo lek");
                      handleGoogleLoginViolation(context, state.toString());
                      AppNavigator.pushReplacement(
                        context,
                        MainWrapper(),
                        // BlocProvider.value(
                        //   value: context.read<AuthStateCubit>(),
                        //   child: MainWrapper(),
                        // ),
                      );
                    } else if (from == "notAuthenticated") {
                      AppBottomsheet.display(
                        context,
                        const FirstSingupSheetContent(methode: "daftar"),
                        // BlocProvider.value(
                        //   value: context.read<AuthStateCubit>(),
                        //   child: const FirstSingupSheetContent(
                        //     methode: "daftar",
                        //   ),
                        // ),
                      );
                    }
                  }
                },

          backgroundColor: state.isNotEmpty
              ? Colors.white
              : AppColors.disableBackgroundButton,
          content: Text(
            "Lanjut",
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          // foregroundColor: AppColors.disableTextButton,
        );
      },
    );
  }
}

// Widget _continueButton(BuildContext context) {
//     return BlocBuilder<RoleCubit, String>(
//       builder: (context, state) {
//         return ElevatedButton(
//           onPressed: state.isNotEmpty
//               ? () {
//                   AppBottomsheet.display(
//                     context,
//                     const FirstSingupSheetContent(),
//                   );
//                 }
//               : null,
//           style: ElevatedButton.styleFrom(
//             padding: EdgeInsets.symmetric(horizontal: 50),
//             backgroundColor: state.isNotEmpty ? Colors.black : Colors.grey,
//             foregroundColor: state.isNotEmpty
//                 ? Colors.white
//                 : AppColors.disableTextButton,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.zero,
//             ),
//           ),
//           child: Text(
//             'Lanjut',
//             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//           ),
//         );
//       },
//     );
//   }
//  GestureDetector(
//                               onTap: () {
//                                 context.read<RoleCubit>().setRole("user");
//                               },
//                               child: Container(
//                                 height: 250,
//                                 decoration: BoxDecoration(
//                                   gradient: state == "user"
//                                       ? LinearGradient(
//                                           colors: [
//                                             Colors.red.shade400,
//                                             Colors.red.shade800,
//                                           ],
//                                           begin: Alignment.topCenter,
//                                           end: Alignment.bottomCenter,
//                                         )
//                                       : null,
//                                   borderRadius: BorderRadius.circular(15.0),
//                                   boxShadow: state == "user"
//                                       ? [
//                                           BoxShadow(
//                                             color: Color.fromRGBO(
//                                               255,
//                                               255,
//                                               255,
//                                               0.3,
//                                             ),
//                                             spreadRadius: 3,
//                                             blurRadius: 5,
//                                             offset: const Offset(0, 0),
//                                           ),
//                                         ]
//                                       : null,
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(15.0),
//                                   child: Image.asset(
//                                     AppImages.user,
//                                     width: 140,
//                                     height: 140,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 context.read<RoleCubit>().setRole("company");
//                               },
//                               child: Container(
//                                 height: 250,
//                                 decoration: BoxDecoration(
//                                   gradient: state == "company"
//                                       ? LinearGradient(
//                                           colors: [
//                                             Colors.blue.shade400,
//                                             Colors.blue.shade800,
//                                           ],
//                                           begin: Alignment.topCenter,
//                                           end: Alignment.bottomCenter,
//                                         )
//                                       : null,
//                                   borderRadius: BorderRadius.circular(15.0),
//                                   boxShadow: state == "company"
//                                       ? [
//                                           BoxShadow(
//                                             color: Color.fromRGBO(
//                                               255,
//                                               255,
//                                               255,
//                                               0.3,
//                                             ),
//                                             spreadRadius: 3,
//                                             blurRadius: 5,
//                                             offset: const Offset(0, 0),
//                                           ),
//                                         ]
//                                       : null,
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(15.0),
//                                   child: Image.asset(
//                                     AppImages.user,
//                                     width: 140,
//                                     height: 140,
//                                   ),
//                                 ),
//                               ),
//                             ),
