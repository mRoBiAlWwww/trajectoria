import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/bloc/navigation/bottom_navigation_jobseeker_cubit.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/pages/create_competition.dart';
import 'package:trajectoria/features/company/dashboard/presentation/pages/dashboard_page.dart';
import 'package:trajectoria/features/company/profile/presentation/pages/company_profile.dart';

class CompanyWrapper extends StatelessWidget {
  const CompanyWrapper({super.key});

  final List<Widget> topLevelPages = const [
    DashboardPage(),
    CompanyProfilePage(),
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
            floatingActionButton: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0XFFB2B2B2), Color(0xFF242424)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.thirdBackGroundButton,
                  width: 7,
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                shape: CircleBorder(),
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () =>
                      AppNavigator.push(context, CreateCompetitionPage()),
                  child: SizedBox(
                    width: 75,
                    height: 75,
                    child: Icon(Icons.add, size: 50, color: Colors.white),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
              label: "Dashboard",
              filledIcon: AppVectors.learnNavbarFilled,
            ),
            SizedBox(width: 25),
            _bottomAppBarItem(
              context,
              defaultIcon: AppVectors.profileNavbar,
              page: 1,
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
        context.read<BottomNavCubit>().changeSelectedIndexCompany(page);
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
                    ? Colors.amber
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
