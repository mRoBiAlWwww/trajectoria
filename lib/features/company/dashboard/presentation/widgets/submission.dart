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
import 'package:trajectoria/main.dart';

class SubmissionWidget extends StatefulWidget {
  final String competitionId;
  const SubmissionWidget({super.key, required this.competitionId});

  @override
  State<SubmissionWidget> createState() => _SubmissionWidgetState();
}

class _SubmissionWidgetState extends State<SubmissionWidget> with RouteAware {
  @override
  void initState() {
    super.initState();

    context.read<OrganizeCompetitionCubit>().getCompetitionById(
      widget.competitionId,
    );
    context.read<JobseekerSubmissionCubit>().getJobseekerSubmissions(
      widget.competitionId,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<OrganizeCompetitionCubit>().getCompetitionById(
      widget.competitionId,
    );
    context.read<JobseekerSubmissionCubit>().getJobseekerSubmissions(
      widget.competitionId,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobseekerSubmissionCubit, JobseekerSubmissionState>(
      listener: (context, submissionsState) {
        if (submissionsState is JobseekerSubmissionsCompetitionLoaded &&
            submissionsState.data.isNotEmpty) {
          final submissionIds = submissionsState.data
              .map((e) => e.submissionId)
              .toList();

          context.read<GetUserCompeCubit>().loadAllUsers(submissionIds);
        }
      },
      builder: (context, submissionsState) {
        if (submissionsState is JobseekerSubmissionsCompetitionLoaded) {
          if (submissionsState.data.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImages.not, width: 100, height: 100),
                const SizedBox(height: 10),
                const Text(
                  "Belum ada unggahan",
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryBackgroundButton,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: BlocBuilder<GetUserCompeCubit, GetUserCompeState>(
              builder: (context, userState) {
                if (userState is UserCompeAllUsersLoaded) {
                  return BlocBuilder<
                    OrganizeCompetitionCubit,
                    OrganizeCompetitionState
                  >(
                    builder: (context, competitionState) {
                      if (competitionState is! OrganizeCompetitionLoaded) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.teal),
                        );
                      }

                      final comp = competitionState.data;
                      final users = userState.users;
                      final submissions = submissionsState.data;

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
                          const SizedBox(height: 10),

                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 15),
                            itemCount: submissions.length,
                            itemBuilder: (context, index) {
                              final submission = submissions[index];
                              final user = users[index];

                              final DateTime submittedAt = submission
                                  .submittedAt
                                  .toDate();
                              final String formattedDate = DateFormat(
                                'd MMM y',
                                'id_ID',
                              ).format(submittedAt);
                              final String countdown = timeAgo(submittedAt);

                              return GestureDetector(
                                onTap: () {
                                  AppNavigator.push(
                                    context,
                                    DetailSubmissionPage(
                                      competition: comp,
                                      submission: submission,
                                      userListed: user,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
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
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: Image.network(
                                          user.profileImage,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                          loadingBuilder:
                                              (context, child, progress) {
                                                if (progress == null)
                                                  return child;
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.grey,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                );
                                              },
                                          errorBuilder: (_, __, ___) =>
                                              const Text('Gagal memuat'),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.name,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                "$countdown • $formattedDate",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
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
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                if (userState is UserCompeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.teal),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        }
        if (submissionsState is JobseekerSubmissionLoading) {
          return Center(child: CircularProgressIndicator(color: Colors.teal));
        }
        return SizedBox.shrink();
      },
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
