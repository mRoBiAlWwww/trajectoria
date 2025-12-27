import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/core/bloc/bottom_navigation_cubit.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';

class CompetitionResultPage extends StatelessWidget {
  final SubmissionEntity? submission;
  final CompetitionEntity? competition;
  final int? totalParticipant;
  final String? competitionId;
  final String? submissionId;

  const CompetitionResultPage({
    super.key,
    this.submission,
    this.competition,
    this.competitionId,
    this.submissionId,
    this.totalParticipant,
  });

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (submission != null && competition != null) {
      bodyContent = _buildContent(
        context,
        submission!,
        competition!,
        totalParticipant!,
      );
    } else {
      bodyContent = BlocProvider(
        create: (context) =>
            SearchCompeteCubit()
              ..getSingleCompetitionAndSubmission(competitionId!),
        child: BlocBuilder<SearchCompeteCubit, SearchCompeteState>(
          builder: (context, searchState) {
            if (searchState is SingleCompeteAndSubmissionLoaded) {
              final sub = searchState.submission;
              final comp = searchState.competition;
              final totalParticipant = searchState.totalCompetitionParticipants;
              if (sub != null) {
                return _buildContent(context, sub, comp, totalParticipant);
              }
            }
            return const SizedBox.shrink();
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.splashBackground,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Column(
              children: [
                Text(
                  "Hasil Kompetisi",
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: bodyContent,
    );
  }

  Widget _buildContent(
    BuildContext context,
    SubmissionEntity submission,
    CompetitionEntity competition,
    int totalParticipant,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              submission.isFinalist
                  ? "Selamat! Kamu termasuk kandidat unggulan🎉"
                  : "Kompetisi selesai👏",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "JetBrainsMono",
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              submission.isFinalist
                  ? "Langkah selanjutnya akan segera diinformasikan"
                  : "Kali ini kamu belum masuk kandidat unggulan, tapi kamu sudah menyelesaikan kompetisi dengan baik",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                color: AppColors.disableTextButton,
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    competition.companyProfileImage,
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  competition.companyName,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryText,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.thirdBackGroundButton,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Skor Akhir",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              color: AppColors.thirdPositiveColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "${submission.score.toInt()}/100",
                            style: TextStyle(
                              fontFamily: "JetBrainsMono",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            "Ranking",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              color: AppColors.thirdPositiveColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.satu,
                                width: 45,
                                height: 45,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "dari $totalParticipant peserta",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.disableTextButton,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Notes",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 3),
            const DottedLine(
              dashGapLength: 0,
              lineThickness: 1,
              dashColor: Color.fromARGB(255, 236, 236, 233),
            ),
            SizedBox(height: 3),
            Text(
              "'${submission.feedback}'",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Contact",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 3),
            const DottedLine(
              dashGapLength: 0,
              lineThickness: 1,
              dashColor: Color.fromARGB(255, 236, 236, 233),
            ),
            SizedBox(height: 3),
            Text(
              "Email: ${competition.companyEmail}",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 85 / 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.thirdBackGroundButton,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Image.asset(AppImages.premiumResult),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 5,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.rocket_launch,
                                  size: 20,
                                  color: AppColors.secondaryText,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Buka AI analisis performa kompetisi",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Dapatkan ringkasan kekuatan & kelemahan dari setiap challenge yang kamu selesaikan.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF4B3480),
                                    Color(0xFFC267FF),
                                    Color(0xFFE5FF9E),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  context
                                      .read<BottomNavCubit>()
                                      .changeSelectedIndexJobseeker(3);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppVectors.upgrade,
                                      width: 15.0,
                                      height: 15.0,
                                    ),
                                    SizedBox(width: 4),
                                    const Text(
                                      "Upgrade Sekarang",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
