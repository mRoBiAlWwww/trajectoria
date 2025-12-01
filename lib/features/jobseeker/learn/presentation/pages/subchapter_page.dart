import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/module_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/module_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/pages/modul_quiz_page.dart';

class SubchapterPage extends StatefulWidget {
  final String courseId;
  final int chapterOrder;
  const SubchapterPage({
    super.key,
    required this.courseId,
    required this.chapterOrder,
  });

  @override
  State<SubchapterPage> createState() => _SubchapterPageState();
}

class _SubchapterPageState extends State<SubchapterPage> {
  final Set<int> _expandedIndices = {};

  // final double _defaultHeight = 75.0;
  // final double _expandedHeight = 350.0;

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChapterCubit()
            ..getChapterAndSubchapters(widget.courseId, widget.chapterOrder),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Kursus",
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<ChapterCubit, ChapterState>(
          builder: (context, state) {
            if (state is ChapterAndSubchaptersLoaded) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text(
                      state.courseChapter.title,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      state.courseChapter.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 225,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined),
                                SizedBox(width: 5),
                                Text(
                                  "${state.courseChapter.duration} Jam",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF87B7B7),
                                    Color(0xFFC7E8E8),
                                  ],
                                ),
                              ),
                              child: Text(
                                "${state.courseChapter.maximumScore} XP",
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.subChapters.length,
                        itemBuilder: (context, index) {
                          final bool isExpanded = _expandedIndices.contains(
                            index,
                          );
                          // final double currentHeight = isExpanded
                          //     ? _expandedHeight
                          //     : _defaultHeight;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              onTap: () => _toggleExpand(index),
                              child: AnimatedContainer(
                                padding: EdgeInsets.all(20),
                                duration: Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.subChapters[index].title,
                                      style: TextStyle(
                                        fontFamily: 'JetBrainsMono',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                    AnimatedSize(
                                      duration: const Duration(
                                        milliseconds: 350,
                                      ),
                                      curve: Curves.easeInOut,
                                      alignment: Alignment.topCenter,
                                      child: isExpanded
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state
                                                        .subChapters[index]
                                                        .description,
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .secondaryText,
                                                      fontSize: 14,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  showModules(
                                                    widget.courseId,
                                                    widget.chapterOrder,
                                                    state
                                                        .subChapters[index]
                                                        .subchapterId,
                                                    index,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox.shrink(),
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
            if (state is ChapterLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget showModules(
    String courseId,
    int chapterOrder,
    String chapterId,
    int itemIndex,
  ) {
    return BlocProvider(
      create: (context) =>
          ModuleCubit()
            ..getModulesAndFinishedModules(courseId, chapterOrder, chapterId),
      child: BlocBuilder<ModuleCubit, ModuleState>(
        builder: (context, state) {
          if (state is ModulesAndFinishedModulesLoaded) {
            if (state.modules.isNotEmpty) {
              return Column(
                children: List.generate(state.modules.length, (index) {
                  bool isCompleted = state.user.contains(
                    state.modules[index].moduleId,
                  );
                  //cek apakah ada module yg sudah selesai
                  return InkWell(
                    onTap: isCompleted
                        ? null
                        : () {
                            AppNavigator.push(
                              context,
                              ModulQuizPage(
                                chapterOrder: widget.chapterOrder,
                                module: state.modules[index],
                                nextModule: index + 1 >= state.modules.length
                                    ? ""
                                    : state.modules[index].title,
                                nextMaximumScore:
                                    index + 1 >= state.modules.length
                                    ? state.modules[index].maximumScore
                                    : 0,
                              ),
                            );
                            _toggleExpand(itemIndex);
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          top: BorderSide(
                            color: AppColors.disableBackgroundButton,
                            width: 1.0,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.description, color: Colors.grey),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    state.modules[index].title,

                                    style: TextStyle(
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryText,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 60),
                          Text(
                            "${state.modules[index].maximumScore.toString()} XP",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              color: Colors.teal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    child: Divider(
                      color: AppColors.thirdBackGroundButton,
                      height: 10,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.thirdBackGroundButton,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.lock_sharp, size: 20),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Icon(
                                Icons.rocket_launch,
                                size: 20,
                                color: AppColors.secondaryText,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Buka Semua Course Premium",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Upgrade ke Premium untuk Akses penuh ke seluruh jalur belajar, XP eksklusif, dan roadmap karier tanpa batas",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF4B3480),
                                  Color(0xFFC267FF),
                                  Color(0xFFE5FF9E),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Aksi tombol
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppVectors.upgrade,
                                    width: 15.0,
                                    height: 15.0,
                                  ),
                                  SizedBox(width: 4),
                                  const Text(
                                    "Upgrade Sekarang",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
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
                ],
              );
            }
          }

          if (state is ModuleLoading) {
            Center(child: const CircularProgressIndicator());
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
