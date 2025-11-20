import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';

class FilterCompetitionSheet extends StatefulWidget {
  final VoidCallback? onApplied;
  const FilterCompetitionSheet({super.key, this.onApplied});

  @override
  State<FilterCompetitionSheet> createState() => _FilterCompetitionSheetState();
}

class _FilterCompetitionSheetState extends State<FilterCompetitionSheet> {
  List<String> selectedCategories = [];
  String deadline = "";

  @override
  void initState() {
    super.initState();
    context.read<SearchCompeteCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCompeteCubit, SearchCompeteState>(
      builder: (context, state) {
        if (state is SearchCategoriesLoaded) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Filter Pencarian",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Kategori",
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Lihat semua",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "JetBrainsMono",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 12.0,
                          children: state.categories.map((tag) {
                            final bool isSelected = selectedCategories.contains(
                              tag.categoryId,
                            );
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedCategories.remove(tag.categoryId);
                                  } else {
                                    selectedCategories.add(tag.categoryId);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.teal
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_box
                                          : Icons.square_outlined,
                                      color: isSelected
                                          ? Colors.teal
                                          : Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      tag.category,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.teal
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Deadline",
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (deadline == "Terlama") {
                                    deadline = "";
                                  } else {
                                    deadline = "Terlama";
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: deadline == "Terlama"
                                        ? Colors.teal
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  "Terlama",
                                  style: TextStyle(
                                    color: deadline == "Terlama"
                                        ? Colors.teal
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (deadline == "Terdekat") {
                                    deadline = "";
                                  } else {
                                    deadline = "Terdekat";
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: deadline == "Terdekat"
                                        ? Colors.teal
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  "Terdekat",
                                  style: TextStyle(
                                    color: deadline == "Terdekat"
                                        ? Colors.teal
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        BasicAppButton(
                          // onPressed: () async {
                          //   await context
                          //       .read<SearchCompeteCubit>()
                          //       .getCompetitionsByFilters(
                          //         selectedCategories,
                          //         deadline,
                          //       );
                          //   debugPrint(state.toString());
                          //   Navigator.pop(context);
                          // },
                          onPressed: () {
                            final cubit = context.read<SearchCompeteCubit>();
                            cubit.getCompetitionsByFilters(
                              selectedCategories,
                              deadline,
                            );
                            Navigator.pop(context);
                            widget.onApplied?.call();
                          },

                          backgroundColor: Colors.black,
                          horizontalPadding: 40,
                          verticalPadding: 10,
                          content: Text(
                            "Terapkan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 10,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      AppVectors.close,
                      width: 40.0,
                      height: 40.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
