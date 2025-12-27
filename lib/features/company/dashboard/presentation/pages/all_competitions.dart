import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/empty_competition/company_empty_competition.dart';
import 'package:trajectoria/common/widgets/listItem/competition_listitem.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
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
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor: AppColors.splashBackground,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
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
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFFBFBFB),
                        Color(0xFFEDEDED),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchCon,
                            onChanged: onSearchChanged,
                            decoration: InputDecoration(
                              filled: false,
                              hintText: "Cari Kompetisi",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.grey.shade700, Color(0xFF242424)],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppVectors.miniFilter,
                                  width: 12.0,
                                  height: 12.0,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Cari",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
