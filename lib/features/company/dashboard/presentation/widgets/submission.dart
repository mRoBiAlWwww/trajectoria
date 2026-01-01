import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/helper/date/date_convert.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/common/widgets/searchbar/searchbar.dart';
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
  final TextEditingController searchCon = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? debounce;
  bool isDone = true;
  String show = "newest";

  void onSearchChanged(String value) {
    value.isNotEmpty ? isDone = false : isDone = true;
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isEmpty) {
        isDone = true;
        context.read<JobseekerSubmissionCubit>().getJobseekerSubmissions(
          widget.competitionId,
          show,
        );
      } else {
        isDone = false;
        context
            .read<JobseekerSubmissionCubit>()
            .getJobseekerSubmissionsByJobsName(value, widget.competitionId);
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });

    context.read<OrganizeCompetitionCubit>().getCompetitionById(
      widget.competitionId,
    );
    context.read<JobseekerSubmissionCubit>().getJobseekerSubmissions(
      widget.competitionId,
      show,
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
    if (searchCon.text.isNotEmpty) {
      context
          .read<JobseekerSubmissionCubit>()
          .getJobseekerSubmissionsByJobsName(
            searchCon.text,
            widget.competitionId,
          );
    } else {
      context.read<JobseekerSubmissionCubit>().getJobseekerSubmissions(
        widget.competitionId,
        show,
      );
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _focusNode.dispose();
    super.dispose();
  }

  void updateFilter(String selectedFilter) {
    String targetFilter;

    if (show == selectedFilter) {
      targetFilter = "newest";
    } else {
      targetFilter = selectedFilter;
    }

    setState(() {
      show = targetFilter;
    });

    context.read<JobseekerSubmissionCubit>().getJobseekerSubmissions(
      widget.competitionId,
      show,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<JobseekerSubmissionCubit, JobseekerSubmissionState>(
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
                              if (competitionState
                                  is OrganizeCompetitionLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.teal,
                                  ),
                                );
                              }
                              if (competitionState
                                  is OrganizeCompetitionLoaded) {
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

                                    Expanded(
                                      child: ListView.separated(
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 15),
                                        itemCount: submissions.length,
                                        itemBuilder: (context, index) {
                                          final submission = submissions[index];
                                          final user = users[index];

                                          //formatter date
                                          final formattedDate = submission
                                              .submittedAt
                                              .toShortDate();
                                          final countdown = submission
                                              .submittedAt
                                              .toTimeAgo();

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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10,
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
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: AppColors
                                                      .thirdBackGroundButton,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                    child: Image.network(
                                                      user.profileImage,
                                                      fit: BoxFit.cover,
                                                      width: 40,
                                                      height: 40,
                                                      loadingBuilder:
                                                          (
                                                            context,
                                                            child,
                                                            progress,
                                                          ) {
                                                            if (progress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return Container(
                                                              width: 50,
                                                              height: 50,
                                                              color:
                                                                  Colors.grey,
                                                              child: const Center(
                                                                child: CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              const Text(
                                                                'Gagal memuat',
                                                              ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Padding(
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
                                                          user.name,
                                                          style:
                                                              const TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          "$countdown • $formattedDate",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .disableTextButton,
                                                            fontSize: 12,
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
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return SizedBox.shrink();
                            },
                          );
                        }
                        if (userState is UserCompeLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.teal,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  );
                }
                if (submissionsState is JobseekerSubmissionLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.teal),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                searchCon.text.isNotEmpty
                    ? SizedBox.shrink()
                    : Row(
                        children: [
                          BasicAppButton(
                            onPressed: () {
                              updateFilter("latest");
                            },
                            isBordered: show != "latest",
                            backgroundColor: show == "latest"
                                ? Colors.black
                                : Colors.transparent,
                            borderColor: AppColors.disableTextButton,
                            horizontalPadding: 15,
                            verticalPadding: 10,
                            content: Text(
                              "Paling lama",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700,
                                color: show == "latest"
                                    ? Colors.white
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          BasicAppButton(
                            onPressed: () {
                              updateFilter("notChecked");
                            },
                            horizontalPadding: 15,
                            verticalPadding: 10,
                            isBordered: show != "notChecked",
                            backgroundColor: show == "notChecked"
                                ? Colors.black
                                : Colors.transparent,
                            borderColor: AppColors.disableTextButton,
                            content: Text(
                              "Belum dinilai",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700,
                                color: show == "notChecked"
                                    ? Colors.white
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 10),
                SearchBarWidget(
                  controller: searchCon,
                  onChanged: onSearchChanged,
                  hint: "Cari Peserta",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
