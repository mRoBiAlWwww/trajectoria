import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  const DetailCompetitionPage({super.key, required this.competitionId});

  @override
  State<DetailCompetitionPage> createState() => _DetailCompetitionPageState();
}

class _DetailCompetitionPageState extends State<DetailCompetitionPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.splashBackground,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "AI Innovation Hackathon",
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0,
      ),
      body: MultiBlocProvider(
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
    );
  }

  Widget buildButton(String label, int index) {
    final bool isSelected = selectedIndex == index;

    return Container(
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0XFFB2B2B2), Color(0xFF242424)],
              )
            : null,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16),
          foregroundColor: isSelected
              ? Colors.white
              : AppColors.disableTextButton,
        ),
        onPressed: () {
          setState(() {
            selectedIndex = index; // update tombol yg dipilih
          });
        },
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
      ),
    );
  }
}
