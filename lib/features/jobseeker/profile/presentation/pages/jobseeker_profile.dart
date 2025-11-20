import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin_or_signup_page.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/editable_teks.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/pages/detail_progress.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/pages/riwayat_kompetisi.dart';

class JobSeekerProfilePage extends StatefulWidget {
  const JobSeekerProfilePage({super.key});

  @override
  State<JobSeekerProfilePage> createState() => _JobSeekerProfilePageState();
}

class _JobSeekerProfilePageState extends State<JobSeekerProfilePage> {
  String bio = "+ Tambahkan bio";
  final List<String> myImages = [
    AppImages.fs,
    AppImages.mobile,
    AppImages.py,
    AppImages.uiux,
    AppImages.be,
  ];

  final List<String> category = [
    "Full-Stack Developer",
    "Mobile Developer",
    "Python Progammer",
    "UI/UX Designer",
    "Back-End Developer",
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint("debugPrint");
    debugPrint(myImages[0]);

    return BlocConsumer<AuthStateCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          AppNavigator.pushAndRemove(context, SigninOrSignupPage());
        }
      },

      builder: (context, state) {
        debugPrint(state.toString());
        if (state is AuthSuccess) {
          debugPrint(state.jobSeeker?.profileImage);
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0.0,
                backgroundColor: AppColors.splashBackground,
                automaticallyImplyLeading: false,
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
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            state.jobSeeker?.profileImage ??
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
                          state.jobSeeker!.name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 250,
                          height: 75,
                          child: EditableTextItem(
                            needWrapText: true,
                            text: bio.isEmpty
                                ? (state.jobSeeker?.bio ??
                                      "+ Tambahkan Deskripsi")
                                : bio,

                            onChanged: (value) {
                              setState(() {
                                bio = value;
                              });
                            },
                          ),
                        ),
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
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          color: Colors.white,
                                          border: Border.all(
                                            color:
                                                AppColors.thirdBackGroundButton,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            CupertinoIcons.bell_solid,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Notifikasi",
                                        style: TextStyle(
                                          fontFamily: 'Iinter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Divider(
                                  color: AppColors.thirdBackGroundButton,
                                  thickness: 1,
                                  height: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  AppNavigator.push(
                                    context,
                                    ProgressDetailPage(
                                      imageUrl:
                                          state.jobSeeker?.profileImage ?? "",
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: AppColors
                                                  .thirdBackGroundButton,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.trending_up_sharp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Progres",
                                          style: TextStyle(
                                            fontFamily: 'Iinter',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Divider(
                                  color: AppColors.thirdBackGroundButton,
                                  thickness: 1,
                                  height: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        AppNavigator.push(
                                          context,
                                          RiwayatKompetisiPage(),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: AppColors
                                                    .thirdBackGroundButton,
                                              ),
                                            ),
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.history,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Riwayat Kompetisi",
                                            style: TextStyle(
                                              fontFamily: 'Iinter',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
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
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Image.asset(AppImages.promo, width: 550, height: 100),
                        SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sertifikat",
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            ListView.separated(
                              shrinkWrap: true, // <— WAJIB
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: myImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Color(0xFFFBFBFB),
                                        Color(0xFFEDEDED),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.thirdBackGroundButton,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                          myImages[index],
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          category[index],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            border: Border.all(
                                              width: 3,
                                              color: AppColors
                                                  .thirdBackGroundButton,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "0%",
                                              style: TextStyle(
                                                fontFamily: 'JetBrainsMono',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 15),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        BasicAppButton(
                          borderRad: 15,
                          onPressed: () {
                            context.read<AuthStateCubit>().reset();
                            context.read<RoleCubit>().clearRole();
                            context.read<AuthStateCubit>().signout();
                          },
                          backgroundColor: AppColors.doveRedColor,
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
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
