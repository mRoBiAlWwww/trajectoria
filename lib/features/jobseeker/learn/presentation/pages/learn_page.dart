import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/toast/toast.dart';
import 'package:trajectoria/core/bloc/bottom_navigation_cubit.dart';
import 'package:trajectoria/common/widgets/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/course_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/finished_chapter_module_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/finished_chapter_module_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_course_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/quiz_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/pages/subchapter_page.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/widgets/roadmap.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/widgets/select_course_path.dart';
import 'package:trajectoria/main.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with RouteAware {
  bool isExpanded = false;
  String? titleToShow;
  JobSeekerEntity? jobseeker;
  late List<String> chapterStatus;
  late List<String> finishedChapters;
  late String onProgresChapters;
  int progress = 0;
  late CourseChapterEntity localChapter;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // fetch();

      final eitherUser = await context.read<AuthStateCubit>().getCurrentUser();
      final result = eitherUser.getOrElse(() => null);

      setState(() {
        jobseeker = result;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() async {
    final eitherUser = await context.read<AuthStateCubit>().getCurrentUser();
    final result = eitherUser.getOrElse(() => null);
    fetch();

    setState(() {
      jobseeker = result;
    });
  }

  void fetch() async {
    //untuk roadmap
    final initialCourse = context.read<HydratedSelectedCourseCubit>().state!;
    context.read<ChapterCubit>().getAllChapters(initialCourse.courseId);
    context.read<FinishedChapterAndModuleCubit>().getFinishedChapters(
      initialCourse.courseId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CourseCubit()),
          BlocProvider(create: (context) => QuizCubit()),
        ],
        child: BlocBuilder<HydratedSelectedCourseCubit, CourseEntity?>(
          builder: (context, selectedCourse) {
            final titleToShow = selectedCourse?.title ?? "Pilih Course...";
            selectedCourse == null ? null : fetch();
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 60, 30, 0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.thirdBackGroundButton,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${jobseeker?.coursesScore.toStringAsFixed(0) ?? 0} XP",

                                      style: TextStyle(
                                        fontFamily: 'JetBrainsMono',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.thirdBackGroundButton,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.local_fire_department_rounded,
                                        size: 35,
                                      ),
                                      Text(
                                        "0",
                                        style: TextStyle(
                                          fontFamily: 'JetBrainsMono',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.thirdBackGroundButton,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    titleToShow,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                      await AppBottomsheet.display(
                                        context,
                                        const SelectCourseSheetContent(),
                                      );
                                      setState(() {
                                        isExpanded = false;
                                      });
                                    },
                                    child: Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up_outlined
                                          : Icons.keyboard_arrow_down_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.thirdBackGroundButton,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Kamu sudah menguasai",
                                            style: TextStyle(
                                              fontFamily: 'JetBrainsMono',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            titleToShow,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: 'JetBrainsMono',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          (jobseeker != null &&
                                                  selectedCourse != null)
                                              ? "${getProgressValue(jobseeker!, selectedCourse.courseId).toString()}%"
                                              : "0%",
                                          style: TextStyle(
                                            fontFamily: 'JetBrainsMono',
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..shader =
                                                  const LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Color(0xFF4B3480),
                                                      Color(0xFFC267FF),
                                                    ],
                                                  ).createShader(
                                                    const Rect.fromLTWH(
                                                      0,
                                                      0,
                                                      200,
                                                      0,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),

                                Container(
                                  height: 14,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.thirdBackGroundButton,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: progress / 100,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xFF4B3480),
                                              Color(0xFFC267FF),
                                              Color(0xFFE5FF9E),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      selectedCourse != null
                          ? BlocBuilder<
                              FinishedChapterAndModuleCubit,
                              FinishedChapterAndModuleState
                            >(
                              builder: (context, chapterModuleState) {
                                if (chapterModuleState
                                    is FinishedChapterAndModuleLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (chapterModuleState
                                    is OnprogresOrFinishedChapterLoaded) {
                                  return RoadmapWidget(
                                    course: selectedCourse,
                                    onProgChap:
                                        chapterModuleState.onprogresChapters,
                                    finishChap:
                                        chapterModuleState.finishedChapters,
                                    //untuk handle course pendahuluan yg cuma 3 subchapter
                                    isChapterZero:
                                        chapterModuleState
                                            .onprogresChapters
                                            ?.orderIndex ==
                                        0,
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            )
                          : Text("Silahkan anda pilih course terlebih dahulu"),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BasicAppButton(
                      onPressed: () {
                        if (selectedCourse != null) {
                          final state = context
                              .read<FinishedChapterAndModuleCubit>()
                              .state;

                          // 2. Cek apakah datanya sudah siap (Loaded)?
                          if (state is OnprogresOrFinishedChapterLoaded) {
                            if (state.onprogresChapters != null) {
                              AppNavigator.push(
                                context,
                                BlocProvider.value(
                                  value: context.read<BottomNavCubit>(),
                                  child: SubchapterPage(
                                    courseId: selectedCourse.courseId,
                                    chapterOrder:
                                        state.onprogresChapters!.orderIndex,
                                    //untuk handle course pendahuluan yg cuma 3 subchapter
                                    isChapterZero:
                                        state.onprogresChapters!.orderIndex == 0
                                        ? true
                                        : false,
                                  ),
                                ),
                              );
                            } else {
                              context.showErrorToast(
                                "Anda belum memilih chapter sama sekali",
                              );
                            }
                          }
                        } else {
                          context.showErrorToast(
                            "Silahkan pilih course terlebih dahulu",
                          );
                        }
                      },
                      verticalPadding: 18,
                      backgroundColor: AppColors.secondaryBackgroundButton,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Lanjut belajar",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  int getProgressValue(JobSeekerEntity jobseeker, String targetCourseId) {
    var matches = jobseeker.progres.where(
      (item) => item.courseId == targetCourseId,
    );

    if (matches.isNotEmpty) {
      return matches.first.valueProgres;
    } else {
      return 0;
    }
  }
}
