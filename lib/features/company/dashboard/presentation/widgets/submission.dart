import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/get_user_compe_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/get_user_compe_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/jobseeker_submission_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/jobseeker_submission_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competition_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competitions_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/pages/detail_submission.dart';

class SubmissionWidget extends StatelessWidget {
  final String competitionId;
  const SubmissionWidget({super.key, required this.competitionId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              JobseekerSubmissionCubit()
                ..getJobseekerSubmissions(competitionId),
        ),
        BlocProvider(
          create: (context) =>
              OrganizeCompetitionCubit()..getCompetitionById(competitionId),
        ),
        BlocProvider(create: (context) => GetUserCompeCubit()),
      ],
      child: BlocBuilder<JobseekerSubmissionCubit, JobseekerSubmissionState>(
        builder: (context, submissionsState) {
          if (submissionsState is JobseekerSubmissionsCompetitionLoaded) {
            if (submissionsState.data.isNotEmpty) {
              final submissionIds = submissionsState.data
                  .map((e) => e.submissionId)
                  .toList();
              context.read<GetUserCompeCubit>().loadAllUsers(submissionIds);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: BlocBuilder<GetUserCompeCubit, GetUserCompeState>(
                  builder: (context, userState) {
                    if (userState is UserCompeAllUsersLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Semua Peserta",
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 15),
                            itemCount: submissionsState.data.length,
                            itemBuilder: (context, index) {
                              if (index >= userState.users.length) {
                                return SizedBox.shrink();
                              }
                              final submission = submissionsState.data[index];
                              final DateTime submittedAtDate = submission
                                  .submittedAt
                                  .toDate();
                              final DateTime deadlineDate = submission
                                  .submittedAt
                                  .toDate();
                              final String formattedDate = DateFormat(
                                'd MMM y',
                                'id_ID',
                              ).format(deadlineDate);
                              final String countdown = timeAgo(submittedAtDate);
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
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.thirdBackGroundButton,
                                    width: 2,
                                  ),
                                ),
                                child:
                                    BlocBuilder<
                                      OrganizeCompetitionCubit,
                                      OrganizeCompetitionState
                                    >(
                                      builder: (context, competitionState) {
                                        if (competitionState
                                            is OrganizeCompetitionLoaded) {
                                          return GestureDetector(
                                            onTap: () {
                                              AppNavigator.push(
                                                context,
                                                DetailSubmissionPage(
                                                  competition:
                                                      competitionState.data,
                                                  submission: submissionsState
                                                      .data[index],
                                                  userListed:
                                                      userState.users[index],
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                  child: Image.network(
                                                    userState
                                                        .users[index]
                                                        .profileImage,
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                    loadingBuilder:
                                                        (
                                                          context,
                                                          child,
                                                          loadingProgress,
                                                        ) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return Container(
                                                            width: 100,
                                                            height: 100,
                                                            color: Colors.grey,
                                                            child: const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return const Center(
                                                            child: Text(
                                                              'Gagal memuat.',
                                                            ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                                SizedBox(width: 10),

                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          userState
                                                              .users[index]
                                                              .name,
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        Text(
                                                          "$countdown - $formattedDate",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .disableTextButton,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return SizedBox.shrink();
                                      },
                                    ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.not, width: 100, height: 100),
                  SizedBox(height: 10),
                  Text(
                    "Belum ada unggahan",
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryBackgroundButton,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Tunggu peserta mengirim jawaban di periode kompetisi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      color: AppColors.disableTextButton,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  String timeAgo(DateTime past) {
    final Duration difference = DateTime.now().difference(past);

    if (difference.inSeconds < 60) {
      return 'baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      final int hours = difference.inHours;
      final int minutes = difference.inMinutes % 60;
      return '$hours jam $minutes menit yang lalu';
    } else {
      final int days = difference.inDays;
      final int hours = difference.inHours % 24;
      return '$days hari $hours jam yang lalu';
    }
  }
}
