import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/bloc/navigation/bottom_navigation_jobseeker_cubit.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/onboarding_compete_page.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/pages/learn_page.dart';
import 'package:trajectoria/features/jobseeker/premium/presentation/pages/premium_page.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/pages/jobseeker_profile.dart';

class JobseekerWrapper extends StatelessWidget {
  JobseekerWrapper({super.key});

  final List<Widget> topLevelPages = [
    LearnPage(),
    OnboardingCompetePage(),
    LeaderboardPage(),
    PremiumPage(),
    JobSeekerProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: Builder(
        builder: (newContext) {
          return Scaffold(
            body: _mainWrapperBody(newContext),
            bottomNavigationBar: _mainWrapperBottomNavBar(newContext),
          );
        },
      ),
    );
  }

  BottomAppBar _mainWrapperBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: AppColors.splashBackground,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.thirdBackGroundButton, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomAppBarItem(
              context,
              defaultIcon: AppVectors.learnNavbar,
              page: 0,
              label: "Learn",
              filledIcon: AppVectors.learnNavbarFilled,
            ),
            _bottomAppBarItem(
              context,
              defaultIcon: AppVectors.competeNavbar,
              page: 1,
              label: "Compete",
              filledIcon: AppVectors.competeNavbarFilled,
            ),
            _bottomAppBarItem(
              context,
              defaultIcon: AppVectors.leaderboardNavbar,
              page: 2,
              label: "Leaderboard",
              filledIcon: AppVectors.leaderboardNavbarFilled,
            ),
            _bottomAppBarItem(
              context,
              defaultIcon: AppVectors.premiumNavbar,
              page: 3,
              label: "Premium",
              filledIcon: AppVectors.premiumNavbarFilled,
            ),
            _bottomAppBarItem(
              context,
              defaultIcon: AppVectors.profileNavbar,
              page: 4,
              label: "Profile",
              filledIcon: AppVectors.profileNavbarFilled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainWrapperBody(BuildContext context) {
    final int currentIndex = context.watch<BottomNavCubit>().state;
    return IndexedStack(index: currentIndex, children: topLevelPages);
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required defaultIcon,
    required page,
    required label,
    required filledIcon,
  }) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BottomNavCubit>(
          context,
        ).changeSelectedIndexJobseeker(page);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            SvgPicture.asset(
              context.watch<BottomNavCubit>().state == page
                  ? filledIcon
                  : defaultIcon,
              width: 30.0,
              height: 30.0,
            ),
            Text(
              label,
              style: TextStyle(
                color: context.watch<BottomNavCubit>().state == page
                    ? Colors.black
                    : Colors.grey,
                fontSize: 10,
                fontWeight: context.watch<BottomNavCubit>().state == page
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
