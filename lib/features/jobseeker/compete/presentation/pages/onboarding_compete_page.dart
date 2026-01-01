import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/list_competition/list_competition_items.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/search_category_competition_page.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/search_competition_page.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/widgets/slider_screen.dart';

class OnboardingCompetePage extends StatefulWidget {
  const OnboardingCompetePage({super.key});

  @override
  State<OnboardingCompetePage> createState() => _OnboardingCompetePageState();
}

class _OnboardingCompetePageState extends State<OnboardingCompetePage> {
  @override
  void initState() {
    super.initState();
    context.read<SearchCompeteCubit>().getCompetitions();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
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
        );
      },
    );
  }
}
