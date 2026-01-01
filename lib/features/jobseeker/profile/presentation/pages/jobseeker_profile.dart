import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/core/bloc/bottom_navigation_cubit.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/core/services/notification_service.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin_or_signup_page.dart';
import 'package:trajectoria/common/widgets/textfield/editable_teks.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/cubit/profile_cubit.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/pages/bookmark_page.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/pages/detail_progress.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/pages/notification_page.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/pages/riwayat_kompetisi.dart';
import 'package:trajectoria/main.dart';

class JobSeekerProfilePage extends StatefulWidget {
  const JobSeekerProfilePage({super.key});

  @override
  State<JobSeekerProfilePage> createState() => _JobSeekerProfilePageState();
}

class _JobSeekerProfilePageState extends State<JobSeekerProfilePage>
    with RouteAware {
  String bio = "+ Tambahkan biodata diri";
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
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getAnnouncements();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<ProfileCubit>().getAnnouncements();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

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
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 250,
                          child: EditableTextItem(
                            source: "profile",
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
                        SizedBox(height: 30),
                        // BlocBuilder<HydratedAnnouncement, List<String>>(
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, announcementState) {
                            if (announcementState is AnnouncementsLoaded) {
                              final readNotification = announcementState
                                  .announcements
                                  .where((e) => !e.isRead)
                                  .toList();
                              return Container(
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
                                    GestureDetector(
                                      onTap: () {
                                        AppNavigator.push(
                                          context,
                                          BlocProvider.value(
                                            value: context.read<ProfileCubit>(),
                                            child: NotificationPage(),
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
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: AppColors
                                                        .thirdBackGroundButton,
                                                  ),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    AppNavigator.push(
                                                      context,
                                                      BlocProvider.value(
                                                        value: context
                                                            .read<
                                                              ProfileCubit
                                                            >(),
                                                        child:
                                                            NotificationPage(),
                                                      ),
                                                    );
                                                  },
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
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: AppColors
                                                      .thirdPositiveColor,
                                                ),
                                                child: Text(
                                                  readNotification.length
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                              ),
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
                                      onTap: () {
                                        AppNavigator.push(
                                          context,
                                          ProgressDetailPage(
                                            imageUrl:
                                                state.jobSeeker?.profileImage ??
                                                "",
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
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: AppColors
                                                        .thirdBackGroundButton,
                                                  ),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    AppNavigator.push(
                                                      context,
                                                      ProgressDetailPage(
                                                        imageUrl:
                                                            state
                                                                .jobSeeker
                                                                ?.profileImage ??
                                                            "",
                                                      ),
                                                    );
                                                  },
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
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(Icons.arrow_forward_ios_rounded),
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
                                      onTap: () {
                                        AppNavigator.push(
                                          context,
                                          BookmarkPage(),
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
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: AppColors
                                                        .thirdBackGroundButton,
                                                  ),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    AppNavigator.push(
                                                      context,
                                                      BookmarkPage(),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.bookmark,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Bookmark",
                                                style: TextStyle(
                                                  fontFamily: 'Iinter',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(Icons.arrow_forward_ios_rounded),
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
                                      onTap: () {
                                        AppNavigator.push(
                                          context,
                                          RiwayatKompetisiPage(),
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
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: AppColors
                                                        .thirdBackGroundButton,
                                                  ),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    AppNavigator.push(
                                                      context,
                                                      RiwayatKompetisiPage(),
                                                    );
                                                  },
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
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(Icons.arrow_forward_ios_rounded),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
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
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: myImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
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
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(18),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              80,
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
                          onPressed: () async {
                            context.read<AuthStateCubit>().reset();
                            context.read<RoleCubit>().clearRole();
                            context.read<AuthStateCubit>().signoutJobseeker();
                            context.read<BottomNavCubit>().reset();
                            await NotificationService.instance.hardLogout();
                          },
                          backgroundColor: AppColors.doveRedColor,
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
                        SizedBox(height: 25),
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
