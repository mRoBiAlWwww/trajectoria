import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/listitem/competition_listitem.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/search_category_competition_page.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/search_competition_page.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/widgets/slider_screen.dart';

class OnboardingCompetePage extends StatelessWidget {
  const OnboardingCompetePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCompeteCubit()..getCompetitions(),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<SearchCompeteCubit, SearchCompeteState>(
              builder: (context, state) {
                if (state is SearchCompeteLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SearchCompeteError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                if (state is SearchCompeteLoaded) {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: SliderScreen(
                              competitions: state.competitions,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 40, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Daftar Kompetisi",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "JetBrainsMono",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext newPageContext) {
                                          return BlocProvider(
                                            create: (context) =>
                                                SearchCompeteCubit(),
                                            child:
                                                SearchCategoryCompetitionPage(),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Lihat Semua",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "JetBrainsMono",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: CompetitionListView(
                                competitions: state.competitions,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 235,
                        left: 30,
                        right: 30,
                        child: Material(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.white, width: 1),
                          ),
                          child: Ink(
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
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext newPageContext) {
                                      return BlocProvider(
                                        create: (context) =>
                                            SearchCompeteCubit(),
                                        child: SearchCompetitionPage(),
                                      );
                                    },
                                  ),
                                );
                              },
                              // splashColor: Colors.cyan,
                              // highlightColor: Colors.yellow,
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.search),
                                        SizedBox(width: 10),
                                        Text(
                                          "Cari Kompetisi",
                                          style: const TextStyle(
                                            fontFamily: "Inter",
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.bolt, color: Colors.amber),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: Text('No data available'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// child: Card(
//                                 color: AppColors.splashBackground,
//                                 margin: const EdgeInsets.symmetric(
//                                   vertical: 8,
//                                   horizontal: 12,
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           (state
//                                                   .competitions[index]
//                                                   .competitionImage
//                                                   .isNotEmpty)
//                                               ? state
//                                                     .competitions[index]
//                                                     .competitionImage[1]
//                                               : 'https://via.placeholder.com/120',
//                                           width: 130,
//                                           height: 130,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                       SizedBox(width: 20),
//                                       Expanded(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "PT Hology Innovation",
//                                                 style: const TextStyle(
//                                                   color: Colors.grey,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 state.competitions[index].title,
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 20,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 10),
//                                               const DottedLine(
//                                                 dashLength: 6,
//                                                 dashGapLength: 3,
//                                                 lineThickness: 1,
//                                                 dashColor: AppColors
//                                                     .disableBackgroundButton,
//                                               ),
//                                               const SizedBox(height: 10),
//                                               Row(
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.flag,
//                                                     size: 16,
//                                                   ),
//                                                   const SizedBox(width: 4),
//                                                   Text(
//                                                     formattedDate,
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: Colors.grey,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Row(
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.emoji_events,
//                                                     size: 16,
//                                                   ),
//                                                   const SizedBox(width: 4),
//                                                   Expanded(
//                                                     child: Text(
//                                                       state
//                                                           .competitions[index]
//                                                           .rewardDescription,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.grey,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
