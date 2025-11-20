import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/listitem/competition_listitem.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/hydrated_history_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/hydrated_history_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/detail_competition_page.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/widgets/filter_competition.dart';

class SearchCompetitionPage extends StatefulWidget {
  const SearchCompetitionPage({super.key});

  @override
  State<SearchCompetitionPage> createState() => _SearchCompetitionPageState();
}

class _SearchCompetitionPageState extends State<SearchCompetitionPage> {
  final TextEditingController searchCon = TextEditingController();
  Timer? debounce;
  bool isDone = true;

  void onSearchChanged(String value) {
    value.isNotEmpty ? isDone = false : isDone = true;
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () async {
      await context.read<SearchCompeteCubit>().getCompetitionsByTitle(value);
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 80,
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFFBFBFB), Color(0xFFEDEDED)],
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: GestureDetector(
              child: IconButton(
                icon: SvgPicture.asset(
                  AppVectors.filter,
                  width: 20.0,
                  height: 20.0,
                ),
                onPressed: () {
                  AppBottomsheet.display(
                    context,
                    BlocProvider.value(
                      value: context.read<SearchCompeteCubit>(),
                      child: FilterCompetitionSheet(
                        onApplied: () {
                          setState(() {
                            isDone = false;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 15),
        titleSpacing: 5,
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFFBFBFB), Color(0xFFEDEDED)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
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
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey.shade700, Color(0xFF242424)],
                    ),
                  ),
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
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
              setState(() {
                isDone = true;
              });
            }
          },
        ),
        backgroundColor: AppColors.splashBackground,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        color: AppColors.thirdBackGroundButton,
        child: BlocBuilder<SearchCompeteCubit, SearchCompeteState>(
          builder: (context, state) {
            return BlocBuilder<HydratedHistoryCubit, HydratedHistoryState>(
              builder: (context, historyState) {
                if (isDone) {
                  if (historyState is HydratedHistoryStored) {
                    if (historyState.competitions.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Riwayat pencarian",
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 12.0,
                              children: historyState.competitions.map((tag) {
                                return GestureDetector(
                                  onTap: () {
                                    AppNavigator.push(
                                      context,
                                      DetailCompetitionPage(competition: tag),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white,
                                          Color(0xFFFBFBFB),
                                          Color(0xFFEDEDED),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.teal,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      tag.title,
                                      style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Center(
                    child: Text("anda masih belum punya history pencarian"),
                  );
                } else {
                  if (state is SearchCompeteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SearchCompeteLoaded) {
                    // isDone = false;
                    if (state.competitions.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "Kompetisi sesuai pencarian - ",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "JetBrainsMono",
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "${state.competitions.length} hasil",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Flexible(
                            fit: FlexFit.loose,
                            child: CompetitionListView(
                              competitions: state.competitions,
                              isBottomRounded: true,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('Tidak ada hasil'));
                    }
                  }
                }
                return SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
