import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/listItem/competition_listitem.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/get_user_compe_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/get_user_compe_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/jobseeker_submission_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/jobseeker_submission_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competition_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competitions_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/pages/all_competitions.dart';
import 'package:trajectoria/features/company/dashboard/presentation/pages/detail_submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAware {
  @override
  void initState() {
    super.initState();

    context.read<OrganizeCompetitionCubit>().getCompetitions();
    context.read<JobseekerSubmissionCubit>().getJobseekerAcrossSubmissions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<OrganizeCompetitionCubit>().getCompetitions();
    context.read<JobseekerSubmissionCubit>().getJobseekerAcrossSubmissions();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCompany =
        (context.watch<AuthStateCubit>().state as AuthSuccess).user.name;
    return BlocProvider(
      create: (context) => GetUserCompeCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildAppBar(context, userCompany),
            body:
                BlocBuilder<OrganizeCompetitionCubit, OrganizeCompetitionState>(
                  builder: (context, competitionState) {
                    if (competitionState is OrganizeCompetitionsLoaded) {
                      final List<CompetitionEntity> allCompetitions =
                          competitionState.data;

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 75),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCompetitionHeader(context),
                              const SizedBox(height: 10),
                              _buildCompetitionListSection(),
                              const SizedBox(height: 30),

                              _buildSubmissionHeader(context),
                              const SizedBox(height: 10),

                              _buildSubmissionListSection(
                                context,
                                allCompetitions,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String userCompany) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.splashBackground,
      toolbarHeight: 75,
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            border: Border.all(color: AppColors.thirdBackGroundButton),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(CupertinoIcons.bell_solid, color: Colors.grey),
          ),
        ),
        SizedBox(width: 25),
      ],
      title: Text(
        "Hai, $userCompany",
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildCompetitionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Kompetisi",
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        TextButton(
          onPressed: () {
            AppNavigator.push(
              context,
              BlocProvider(
                create: (context) => OrganizeCompetitionCubit(),
                child: const AllCompetitionsPage(),
              ),
            );
          },
          child: const Text(
            "Lihat Semua",
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompetitionListSection() {
    return BlocBuilder<OrganizeCompetitionCubit, OrganizeCompetitionState>(
      builder: (context, competitionState) {
        if (competitionState is OrganizeCompetitionLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (competitionState is OrganizeCompetitionsLoaded) {
          if (competitionState.data.isNotEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return CompetitionListView(
                  isBottomRounded: true,
                  competitions: competitionState.data,
                  isNotScrollable: true,
                  isJobseeker: false,
                );
              },
            );
          } else {
            return _buildEmptyStateCompetition(context);
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSubmissionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Pengumpulan",
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionListSection(
    BuildContext context,
    List<CompetitionEntity> allCompetitions,
  ) {
    return BlocBuilder<JobseekerSubmissionCubit, JobseekerSubmissionState>(
      builder: (context, submissionState) {
        if (submissionState is JobseekerSubmissionsCompetitionLoaded) {
          if (submissionState.data.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada pengumpulan tugas.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final submissionIds = submissionState.data
              .map((e) => e.submissionId)
              .toList();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<GetUserCompeCubit>().loadAllUsers(submissionIds);
          });

          return BlocBuilder<GetUserCompeCubit, GetUserCompeState>(
            builder: (context, userState) {
              if (userState is UserCompeAllUsersLoaded) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // WAJIB MATI
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemCount: submissionState.data.length,
                  itemBuilder: (context, index) {
                    if (index >= userState.users.length) {
                      return const SizedBox.shrink();
                    }

                    final submission = submissionState.data[index];
                    final user = userState.users[index];

                    final CompetitionEntity competitionDetails = allCompetitions
                        .firstWhere(
                          (comp) =>
                              comp.competitionId == submission.competitionId,
                          orElse: () => throw Exception(
                            'Competition ID tidak ditemukan.',
                          ),
                        );

                    final submittedAtDate = submission.submittedAt.toDate();
                    final formattedDate = DateFormat(
                      'd MMM y',
                      'id_ID',
                    ).format(submittedAtDate);
                    final countdown = timeAgo(submittedAtDate);

                    return GestureDetector(
                      onTap: () {
                        AppNavigator.push(
                          context,
                          DetailSubmissionPage(
                            competition: competitionDetails,
                            submission: submission,
                            userListed: user,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.thirdBackGroundButton,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                user.profileImage,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Text('!'));
                                },
                              ),
                            ),
                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "$countdown - $formattedDate",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.disableTextButton,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildEmptyStateCompetition(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Image.asset(AppImages.not, width: 100, height: 100)],
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
