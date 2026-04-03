import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/get_user_compe_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/jobseeker_submission_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competitions_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/finalis.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/rank.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/settings.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/submission.dart';

class DetailCompetitionPage extends StatefulWidget {
  final String competitionId;
  final String competitionName;
  const DetailCompetitionPage({
    super.key,
    required this.competitionId,
    required this.competitionName,
  });

  @override
  State<DetailCompetitionPage> createState() => _DetailCompetitionPageState();
}

class _DetailCompetitionPageState extends State<DetailCompetitionPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: AppColors.splashBackground,
        showLeading: true,
        title: Text(
          widget.competitionName,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0,
      ),
      body: FadeTransition(
        opacity: CurvedAnimation(
          parent: _entranceController,
          curve: Curves.easeOut,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          )),
          child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => JobseekerSubmissionCubit()),
          BlocProvider(create: (context) => OrganizeCompetitionCubit()),
          BlocProvider(create: (context) => GetUserCompeCubit()),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.thirdBackGroundButton,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        buildButton("Unggahan", 0),
                        SizedBox(width: 10),
                        buildButton("Peringkat", 1),
                        SizedBox(width: 10),
                        buildButton("Finalis", 2),
                        SizedBox(width: 10),
                        buildButton("Pengaturan", 3),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (selectedIndex == 0) {
                      return SubmissionWidget(
                        competitionId: widget.competitionId,
                      );
                    } else if (selectedIndex == 1) {
                      return RankWidget(competitionId: widget.competitionId);
                    } else if (selectedIndex == 2) {
                      return FinalisWidget(competitionId: widget.competitionId);
                    } else {
                      return SettingsWidget(
                        competitionId: widget.competitionId,
                      );
                    }
                  },
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

  Widget buildButton(String label, int index) {
    final bool isSelected = selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: 120,
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0XFFB2B2B2), Color(0xFF242424)],
              )
            : null,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: isSelected
              ? Colors.white
              : AppColors.disableTextButton,
        ),
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
            color: isSelected ? Colors.white : AppColors.disableTextButton,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
