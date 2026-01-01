import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/common/widgets/empty_competition/company_empty_competition.dart';
import 'package:trajectoria/common/widgets/list_competition/list_competition_items.dart';
import 'package:trajectoria/common/widgets/searchbar/searchbar.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/draft_or_competitions_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competition_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competitions_cubit.dart';

class AllCompetitionsPage extends StatefulWidget {
  const AllCompetitionsPage({super.key});

  @override
  State<AllCompetitionsPage> createState() => _AllCompetitionsPageState();
}

class _AllCompetitionsPageState extends State<AllCompetitionsPage> {
  final TextEditingController searchCon = TextEditingController();
  Timer? debounce;
  bool isDone = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<OrganizeCompetitionCubit>()
          .getCompetitionsByCurrentCompany();
    });
  }

  void onSearchChanged(String value) {
    value.isNotEmpty ? isDone = false : isDone = true;
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isEmpty) {
        isDone = true;
        context
            .read<OrganizeCompetitionCubit>()
            .getCompetitionsByCurrentCompany();
      } else {
        isDone = false;
        context.read<OrganizeCompetitionCubit>().getCompetitionsByTitle(value);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DraftOrCompetitionsCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              backgroundColor: AppColors.splashBackground,
              onLeadingPressed: () {
                if (isDone) {
                  Navigator.pop(context);
                } else {
                  searchCon.clear();
                  context
                      .read<OrganizeCompetitionCubit>()
                      .getCompetitionsByCurrentCompany();
                  setState(() {
                    isDone = true;
                  });
                }
              },
              title: SearchBarWidget(
                controller: searchCon,
                onChanged: onSearchChanged,
                hint: "Cari Kompetisi",
              ),
            ),
            body: BlocBuilder<DraftOrCompetitionsCubit, String>(
              builder: (context, widgetState) {
                final isCompetitionsPage = widgetState == "Competitions";
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        width: 250,
                        decoration: BoxDecoration(
                          color: AppColors.disableBackgroundButton,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            /// Competitions Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<OrganizeCompetitionCubit>()
                                      .getCompetitionsByCurrentCompany();
                                  context
                                      .read<DraftOrCompetitionsCubit>()
                                      .select("Competitions");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  decoration: isCompetitionsPage
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0XFFB2B2B2),
                                              Color(0xFF242424),
                                            ],
                                          ),
                                        )
                                      : null,
                                  child: Center(
                                    child: Text(
                                      "Semua",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        color: isCompetitionsPage
                                            ? Colors.white
                                            : AppColors.secondaryText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// Draft Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<OrganizeCompetitionCubit>()
                                      .getDraftCompetitions();
                                  context
                                      .read<DraftOrCompetitionsCubit>()
                                      .select("Drafts");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  decoration: !isCompetitionsPage
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0XFFB2B2B2),
                                              Color(0xFF242424),
                                            ],
                                          ),
                                        )
                                      : null,
                                  child: Center(
                                    child: Text(
                                      "Drafts",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        color: !isCompetitionsPage
                                            ? Colors.white
                                            : AppColors.secondaryText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          BlocBuilder<
                            OrganizeCompetitionCubit,
                            OrganizeCompetitionState
                          >(
                            builder: (context, state) {
                              if (state is OrganizeCompetitionLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (state is OrganizeCompetitionFailure) {
                                return Center(child: Text(state.message));
                              }

                              if (isDone) {
                                if (state is OrganizeDraftCompetitionLoaded) {
                                  if (state.data.isNotEmpty) {
                                    return SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Draft Kompetisi Anda",
                                            style: TextStyle(
                                              fontFamily: 'JetBrainsMono',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          CompetitionListView(
                                            isBottomRounded: true,
                                            competitions: state.data,
                                            isNotScrollable: true,
                                            isJobseeker: false,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppImages.not,
                                            width: 100,
                                            height: 100,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Belum ada Draft yang anda buat",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'JetBrainsMono',
                                              fontWeight: FontWeight.w800,
                                              color: AppColors
                                                  .secondaryBackgroundButton,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    );
                                  }
                                }
                                if (state is OrganizeCompetitionsLoaded) {
                                  if (state.data.isNotEmpty) {
                                    return SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Semua Kompetisi",
                                            style: TextStyle(
                                              fontFamily: 'JetBrainsMono',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          CompetitionListView(
                                            isBottomRounded: true,
                                            competitions: state.data,
                                            isNotScrollable: true,
                                            isJobseeker: false,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return CompanyEmptyCompetition();
                                  }
                                }
                              } else {
                                if (state is OrganizeCompetitionsLoaded) {
                                  if (state.data.isNotEmpty) {
                                    return SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Semua Kompetisi",
                                            style: TextStyle(
                                              fontFamily: 'JetBrainsMono',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          CompetitionListView(
                                            isBottomRounded: true,
                                            competitions: state.data,
                                            isNotScrollable: true,
                                            isJobseeker: false,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return CompanyEmptyCompetition();
                                  }
                                }
                              }
                              return SizedBox.shrink();
                            },
                          ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
