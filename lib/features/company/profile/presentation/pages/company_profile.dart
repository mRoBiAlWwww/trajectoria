import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/core/bloc/bottom_navigation_cubit.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin_or_signup_page.dart';
import 'package:trajectoria/common/widgets/textfield/editable_teks.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  String bio = "+ Tambahkan Deskripsi";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthStateCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          AppNavigator.pushAndRemove(context, SigninOrSignupPage());
        }
      },
      builder: (context, state) {
        if (state is AuthSuccess) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: CustomAppBar(
                backgroundColor: AppColors.splashBackground,
                leadingWidth: 0,
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          state.company?.profileImage ??
                              "https://via.placeholder.com/150",
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('Gagal memuat.'));
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        state.company!.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: EditableTextItem(
                          source: "profile",
                          needWrapText: true,
                          text: bio.isEmpty
                              ? (state.company?.companyDescription ??
                                    "+ Tambahkan Deskripsi")
                              : bio,

                          onChanged: (value) {
                            setState(() {
                              bio = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFFFBFBFB),
                              Color(0xFFEDEDED),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.thirdBackGroundButton,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.thirdBackGroundButton,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      CupertinoIcons.bell_solid,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Notifikasi",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    width: 10.0,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward_ios_rounded),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      BasicAppButton(
                        onPressed: () {
                          context.read<AuthStateCubit>().reset();
                          context.read<RoleCubit>().clearRole();
                          context.read<AuthStateCubit>().signoutCompany();
                          context.read<BottomNavCubit>().reset();
                        },
                        backgroundColor: AppColors.doveRedColor,
                        borderRad: 18,
                        verticalPadding: 10,
                        content: Text(
                          "Keluar",
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
