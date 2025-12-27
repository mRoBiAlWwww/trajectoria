import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/core/navigation/main_wrapper.dart';
import 'package:trajectoria/features/authentication/domain/entities/unrole_entity.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
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
        child: SizedBox(
          height: 250,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                        colors: activeGradientColors,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: activeGlowColor,
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(imagePath, width: 140, height: 140),
                        const SizedBox(height: 15),
                        Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'Britanica',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                      _handleGoogleLoginViolation(context, state.toString());
                      AppNavigator.pushReplacement(context, MainWrapper());
                    } else if (from == "notAuthenticated") {
                      AppBottomsheet.display(
                        context,
                        const FirstSingupSheetContent(methode: "daftar"),
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

  Future<void> _handleGoogleLoginViolation(
    BuildContext context,
    String role,
  ) async {
    debugPrint(role);
    final authCubit = context.read<AuthStateCubit>();

    final eitherUser = await authCubit.getCurrentUser();
    final UnroleEntity user = eitherUser.getOrElse(() => null);
    if (role == "Jobseeker") {
      await authCubit.additionalUserInfoJobSeeker(user.toJobseekerSignupReq());
    } else {
      await authCubit.additionalUserInfoCompany(user.toCompanySignupReq());
    }
  }
}
