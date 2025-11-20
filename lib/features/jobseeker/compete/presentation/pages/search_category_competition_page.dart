import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/listitem/competition_listitem.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/category.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';

class SearchCategoryCompetitionPage extends StatefulWidget {
  const SearchCategoryCompetitionPage({super.key});

  @override
  State<SearchCategoryCompetitionPage> createState() =>
      _SearchCategoryCompetitionPageState();
}

class _SearchCategoryCompetitionPageState
    extends State<SearchCategoryCompetitionPage> {
  final TextEditingController searchCon = TextEditingController();
  Timer? debounce;
  CategoryEntity? category;

  void onSearchChanged(String value) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () async {
      await context.read<SearchCompeteCubit>().getCompetitionsByTitle(value);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchCompeteCubit>().getCategories();
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
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        titleSpacing: 40,
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFFBFBFB), Color(0xFFEDEDED)],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 18, color: Colors.black),
              SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: searchCon,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: "Cari Kompetisi",
                    hintStyle: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.splashBackground,
      ),
      body: BlocBuilder<SearchCompeteCubit, SearchCompeteState>(
        builder: (context, state) {
          if (state is SearchCompeteLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hasil pencarian kategori: ${category?.category ?? '-'}",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Flexible(
                    fit: FlexFit.loose,
                    child: CompetitionListView(
                      competitions: state.competitions,
                      isBottomRounded: true,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is SearchCategoriesLoaded) {
            debugPrint(state.categories[0].category);
            return Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.thirdBackGroundButton,
                    Color(0xFFEBEAEA),
                    AppColors.splashBackground,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Kategori",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              category = state.categories[index];
                            });
                            context
                                .read<SearchCompeteCubit>()
                                .getCompetitionsByCategory(
                                  state.categories[index].categoryId,
                                );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
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
                                  color: AppColors.disableBackgroundButton,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    state.categories[index].imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      state.categories[index].category,
                                      style: TextStyle(
                                        fontFamily: 'JetBrainsMono',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
  }
}
