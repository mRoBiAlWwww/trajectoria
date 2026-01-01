import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/core/bloc/bottom_navigation_cubit.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/subchapter.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/finished_chapter_module_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/finished_chapter_module_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/pages/modul_quiz_page.dart';
import 'package:trajectoria/main.dart';

class SubchapterPage extends StatefulWidget {
  final String courseId;
  final int chapterOrder;
  final bool isChapterZero;
  const SubchapterPage({
    super.key,
    required this.courseId,
    required this.chapterOrder,
    required this.isChapterZero,
  });

  @override
  State<SubchapterPage> createState() => _SubchapterPageState();
}

class _SubchapterPageState extends State<SubchapterPage> with RouteAware {
  final Set<String> _expandedIds = {};

  void _toggleExpand(
    BuildContext context,
    int index,
    String courseId,
    int chapterOrder,
    String subchapterId,
  ) {
    setState(() {
      if (_expandedIds.contains(subchapterId)) {
        _expandedIds.remove(subchapterId);
      } else {
        _expandedIds.add(subchapterId);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    context.read<ChapterCubit>().getChapterAndSubchaptersAndFinishedSubchapters(
      widget.courseId,
      widget.chapterOrder,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<ChapterCubit>().getChapterAndSubchaptersAndFinishedSubchapters(
      widget.courseId,
      widget.chapterOrder,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        showLeading: true,
        title: const Text(
          "Kursus",
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<ChapterCubit, ChapterState>(
        builder: (context, state) {
          if (state is ChapterAndSubchaptersAndFinishedSubchaptersLoaded) {
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
                                colors: [Color(0xFF87B7B7), Color(0xFFC7E8E8)],
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(state.subChapters.length, (
                          index,
                        ) {
                          final subchapter = state.subChapters[index];
                          final itemId = subchapter.subchapterId;
                          final isExpanded = _expandedIds.contains(itemId);
                          bool isCompletedSubchapter = state.user.contains(
                            state.subChapters[index].subchapterId,
                          );
                          return BlocProvider(
                            create: (context) =>
                                FinishedChapterAndModuleCubit(),
                            child: Builder(
                              builder: (context) {
                                return Padding(
                                  key: ValueKey(itemId),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!isExpanded) {
                                        context
                                            .read<
                                              FinishedChapterAndModuleCubit
                                            >()
                                            .getModulesAndFinishedModules(
                                              widget.courseId,
                                              widget.chapterOrder,
                                              itemId,
                                            );
                                      }
                                      _toggleExpand(
                                        context,
                                        index,
                                        widget.courseId,
                                        widget.chapterOrder,
                                        state.subChapters[index].subchapterId,
                                      );
                                    },
                                    child: AnimatedContainer(
                                      padding: EdgeInsets.all(20),
                                      duration: Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        color: isCompletedSubchapter
                                            ? Colors.green
                                            : null,
                                        border: Border.all(
                                          color: isCompletedSubchapter
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.subChapters[index].title,
                                            style: TextStyle(
                                              fontFamily: 'JetBrainsMono',
                                              fontWeight: FontWeight.w700,
                                              color: isCompletedSubchapter
                                                  ? Colors.white
                                                  : Colors.black,
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          state
                                                              .subChapters[index]
                                                              .description,
                                                          style: TextStyle(
                                                            color:
                                                                isCompletedSubchapter
                                                                ? Colors.white
                                                                : AppColors
                                                                      .secondaryText,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        showModules(
                                                          context,
                                                          widget.chapterOrder,
                                                          state
                                                              .subChapters[index],
                                                          state
                                                              .courseChapter
                                                              .badge,
                                                          index,
                                                          isCompletedSubchapter,
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
                          );
                        }),
                      ),
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
    );
  }

  Widget showModules(
    BuildContext context,
    int chapterOrder,
    SubChapterEntity subchapter,
    String badge,
    int itemId,
    bool isCompletedSubchapter,
  ) {
    return BlocBuilder<
      FinishedChapterAndModuleCubit,
      FinishedChapterAndModuleState
    >(
      builder: (context, state) {
        if (state is ModulesAndFinishedModulesLoaded) {
          if (state.modules.isNotEmpty) {
            return Column(
              children: List.generate(state.modules.length, (index) {
                bool isCompletedModule = state.user.contains(
                  state.modules[index].moduleId,
                );
                //cek apakah ada module yg sudah selesai
                return InkWell(
                  onTap: isCompletedModule
                      ? null
                      : () {
                          AppNavigator.push(
                            context,
                            ModulQuizPage(
                              badge: badge,
                              chapterOrder: chapterOrder,
                              module: state.modules[index],
                              subchapter: subchapter,
                              nextModule: index + 1 < state.modules.length
                                  ? state.modules[index + 1].title
                                  : "",
                              nextMaximumScore: index + 1 < state.modules.length
                                  ? state.modules[index + 1].maximumScore
                                  : 0,
                              isChapterZero: widget.isChapterZero,
                            ),
                          );
                          _toggleExpand(
                            context,
                            index,
                            widget.courseId,
                            widget.chapterOrder,
                            subchapter.subchapterId,
                          );
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
                              Icon(
                                Icons.description,
                                color: isCompletedSubchapter
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  state.modules[index].title,

                                  style: TextStyle(
                                    decoration: isCompletedModule
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    color: isCompletedSubchapter
                                        ? Colors.white
                                        : AppColors.secondaryText,
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
                            color: isCompletedSubchapter
                                ? Colors.white
                                : Colors.teal,
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
                              Navigator.pop(context);
                              context
                                  .read<BottomNavCubit>()
                                  .changeSelectedIndexJobseeker(3);
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

        if (state is FinishedChapterAndModuleLoading) {
          return Center(child: const CircularProgressIndicator());
        }

        return SizedBox.shrink();
      },
    );
  }
}
