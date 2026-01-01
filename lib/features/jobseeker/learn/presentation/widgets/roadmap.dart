import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/toast/toast.dart';
import 'package:trajectoria/core/bloc/bottom_navigation_cubit.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/finished_chapter_module_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/quiz_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/pages/subchapter_page.dart';

class RoadmapWidget extends StatefulWidget {
  final CourseEntity? course;
  final CourseChapterEntity? onProgChap;
  final List<String> finishChap;
  final bool isChapterZero;

  const RoadmapWidget({
    super.key,
    required this.course,
    required this.onProgChap,
    required this.finishChap,
    required this.isChapterZero,
  });

  @override
  State<RoadmapWidget> createState() => _RoadmapWidgetState();
}

class _RoadmapWidgetState extends State<RoadmapWidget> {
  late List<String> chapterStatus;
  late List<String> finishedChapters;
  late String onProgresChapters;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChapterCubit, ChapterState>(
      builder: (context, chapterState) {
        onProgresChapters = widget.onProgChap?.chapterId ?? "";
        finishedChapters = widget.finishChap;
        if (chapterState is ChapterLoaded) {
          if (chapterState.courseChapter.isNotEmpty) {
            generateChapterStatus(
              chapterState.courseChapter,
              finishedChapters,
              onProgresChapters,
            );
            return Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(40, 50, 40, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          bottom: 100,
                          left: -40,
                          right: -40,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryBackgroundButton,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Premium membuka semua course, misi spesial, XP, badge, dan tantangan eksklusif menantimu",
                                          style: TextStyle(
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SvgPicture.asset(
                                          AppVectors.rocket,
                                          width: 65.0,
                                          height: 65.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 18),
                                  Container(
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
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<BottomNavCubit>()
                                            .changeSelectedIndexJobseeker(3);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            AppVectors.upgrade,
                                            width: 20.0,
                                            height: 20.0,
                                          ),
                                          SizedBox(width: 10),
                                          const Text(
                                            "Upgrade Sekarang",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
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
                        ),
                        SizedBox(height: 1000),
                        DottedBorder(
                          color: const Color.fromARGB(255, 184, 184, 184),
                          strokeWidth: 2,
                          dashPattern: const [4, 2],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(15),
                          child: SizedBox(
                            height: 200,
                            width: 275,
                            child: Center(child: SizedBox.shrink()),
                          ),
                        ),
                        Positioned(
                          top: -15,
                          left: 70,
                          child: Container(
                            height: 225,
                            width: 225,
                            decoration: BoxDecoration(
                              color: AppColors.splashBackground,
                            ),
                          ),
                        ),
                        Positioned(
                          // chapter 0
                          top: -50,
                          left: 80,
                          child: GestureDetector(
                            onTap: () {
                              if (widget.course == null) {
                                context.showErrorToast(
                                  "Silahkan pilih course terlebih dahulu sebelum memulai",
                                );
                                return;
                              }
                              final chapterId =
                                  chapterState.courseChapter[0].chapterId;
                              // 🔒 LOCK → tambah ke on progress
                              if (chapterStatus[0] == "lock") {
                                context.read<QuizCubit>().addOnprogresChapter(
                                  chapterId,
                                );
                                context.showSuccessToast(
                                  "Course telah berhasil dibuka",
                                );
                                context.read<QuizCubit>().addOnprogresChapter(
                                  chapterId,
                                );
                                context.read<ChapterCubit>().getAllChapters(
                                  widget.course!.courseId,
                                );
                                context
                                    .read<FinishedChapterAndModuleCubit>()
                                    .getFinishedChapters(
                                      widget.course?.courseId ?? "",
                                    );
                                return;
                              }
                              // ▶ ON PROGRESS → masuk ke subchapter
                              if (chapterStatus[0] == "onprogres") {
                                AppNavigator.push(
                                  context,
                                  BlocProvider.value(
                                    value: context.read<BottomNavCubit>(),
                                    child: SubchapterPage(
                                      courseId: widget.course!.courseId,
                                      chapterOrder: 0,
                                      isChapterZero: widget.isChapterZero,
                                    ),
                                  ),
                                );
                                return;
                              }
                              // ✅ DONE → tidak bisa diklik
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: chapterStatus[0] == "onprogres"
                                    ? Border.symmetric(
                                        vertical: BorderSide(
                                          color:
                                              AppColors.thirdBackGroundButton,
                                          width: 6,
                                        ),
                                        horizontal: BorderSide(
                                          color:
                                              AppColors.thirdBackGroundButton,
                                          width: 8,
                                        ),
                                      )
                                    : null,
                                color: Colors.white,
                              ),
                              child: chapterStatus[0] == "onprogres"
                                  ? Center(
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        size: 50,
                                      ),
                                    )
                                  : chapterStatus[0] == "lock"
                                  ? Center(child: Icon(Icons.lock))
                                  : Center(child: Icon(Icons.check, size: 50)),
                            ),
                          ),
                        ),
                        Positioned(
                          //chapter 1
                          top: 63,
                          left: -50,
                          child: Container(
                            height: 70,
                            width: 100,
                            alignment: Alignment.center,
                            color: AppColors.splashBackground,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.course == null) {
                                  context.showErrorToast(
                                    "Silahkan pilih course terlebih dahulu sebelum memulai",
                                  );
                                  return;
                                }
                                final chapterId =
                                    chapterState.courseChapter[1].chapterId;

                                // 🔒 LOCK → tambah ke on progress
                                if (chapterStatus[1] == "lock") {
                                  if (chapterStatus[0] != "done") {
                                    context.showErrorToast(
                                      "Selesaikan dahulu course sebelumnya",
                                    );
                                    return;
                                  }
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.showSuccessToast(
                                    "Course telah berhasil dibuka",
                                  );
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.read<ChapterCubit>().getAllChapters(
                                    widget.course!.courseId,
                                  );
                                  context
                                      .read<FinishedChapterAndModuleCubit>()
                                      .getFinishedChapters(
                                        widget.course?.courseId ?? "",
                                      );
                                  return;
                                }
                                // ▶ ON PROGRESS → masuk ke subchapter
                                if (chapterStatus[1] == "onprogres") {
                                  AppNavigator.push(
                                    context,
                                    BlocProvider.value(
                                      value: context.read<BottomNavCubit>(),
                                      child: SubchapterPage(
                                        courseId: widget.course!.courseId,
                                        chapterOrder: 1,
                                        isChapterZero: widget.isChapterZero,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                // ✅ DONE → tidak bisa diklik
                              },
                              child: Container(
                                height: 45,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: chapterStatus[1] == "onprogres"
                                      ? Border.symmetric(
                                          vertical: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                          horizontal: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: chapterStatus[1] == "onprogres"
                                      ? Text(
                                          "Bab 1",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : chapterStatus[1] == "lock"
                                      ? lock()
                                      : Center(
                                          child: Icon(Icons.check, size: 50),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 205,
                          right: 0,
                          child: DottedBorder(
                            color: const Color.fromARGB(255, 184, 184, 184),
                            strokeWidth: 2,
                            dashPattern: const [4, 2],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(15),
                            child: SizedBox(
                              height: 202,
                              width: 125,
                              child: Center(child: SizedBox.shrink()),
                            ),
                          ),
                        ),
                        Positioned(
                          //chapter 2
                          top: 170,
                          left: 75,
                          child: Container(
                            height: 70,
                            width: 100,
                            alignment: Alignment.center,
                            color: AppColors.splashBackground,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.course == null) {
                                  context.showErrorToast(
                                    "Silahkan pilih course terlebih dahulu sebelum memulai",
                                  );
                                  return;
                                }
                                final chapterId =
                                    chapterState.courseChapter[2].chapterId;

                                if (chapterStatus[2] == "lock") {
                                  if (chapterStatus[1] != "done") {
                                    context.showErrorToast(
                                      "Selesaikan dahulu course sebelumnya",
                                    );
                                    return;
                                  }
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.showSuccessToast(
                                    "Course telah berhasil dibuka",
                                  );
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.read<ChapterCubit>().getAllChapters(
                                    widget.course!.courseId,
                                  );
                                  context
                                      .read<FinishedChapterAndModuleCubit>()
                                      .getFinishedChapters(
                                        widget.course?.courseId ?? "",
                                      );
                                  return;
                                }
                                if (chapterStatus[2] == "onprogres") {
                                  AppNavigator.push(
                                    context,
                                    BlocProvider.value(
                                      value: context.read<BottomNavCubit>(),
                                      child: SubchapterPage(
                                        courseId: widget.course!.courseId,
                                        chapterOrder: 3,
                                        isChapterZero: widget.isChapterZero,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              },
                              child: Container(
                                height: 45,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: chapterStatus[2] == "onprogres"
                                      ? Border.symmetric(
                                          vertical: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                          horizontal: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: chapterStatus[2] == "onprogres"
                                      ? Text(
                                          "Bab 2",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : chapterStatus[2] == "lock"
                                      ? lock()
                                      : Center(
                                          child: Icon(Icons.check, size: 50),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 240,
                          left: 70,
                          child: Container(
                            height: 150,
                            width: 110,
                            decoration: BoxDecoration(
                              color: AppColors.splashBackground,
                            ),
                          ),
                        ),
                        Positioned(
                          //chapter 3
                          top: 270,
                          right: -50,
                          child: Container(
                            height: 70,
                            width: 100,
                            alignment: Alignment.center,
                            color: AppColors.splashBackground,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.course == null) {
                                  context.showErrorToast(
                                    "Silahkan pilih course terlebih dahulu sebelum memulai",
                                  );
                                  return;
                                }
                                final chapterId =
                                    chapterState.courseChapter[3].chapterId;

                                if (chapterStatus[3] == "lock") {
                                  if (chapterStatus[2] != "done") {
                                    context.showErrorToast(
                                      "Selesaikan dahulu course sebelumnya",
                                    );
                                    return;
                                  }
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.showSuccessToast(
                                    "Course telah berhasil dibuka",
                                  );
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.read<ChapterCubit>().getAllChapters(
                                    widget.course!.courseId,
                                  );
                                  context
                                      .read<FinishedChapterAndModuleCubit>()
                                      .getFinishedChapters(
                                        widget.course?.courseId ?? "",
                                      );
                                  return;
                                }
                                if (chapterStatus[3] == "onprogres") {
                                  AppNavigator.push(
                                    context,
                                    BlocProvider.value(
                                      value: context.read<BottomNavCubit>(),
                                      child: SubchapterPage(
                                        courseId: widget.course!.courseId,
                                        chapterOrder: 3,
                                        isChapterZero: widget.isChapterZero,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              },
                              child: Container(
                                height: 45,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: chapterStatus[3] == "onprogres"
                                      ? Border.symmetric(
                                          vertical: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                          horizontal: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: chapterStatus[3] == "onprogres"
                                      ? Text(
                                          "Bab 3",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : chapterStatus[3] == "lock"
                                      ? lock()
                                      : Center(
                                          child: Icon(Icons.check, size: 50),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 410,
                          left: 0,
                          child: DottedBorder(
                            color: const Color.fromARGB(255, 184, 184, 184),
                            strokeWidth: 2,
                            dashPattern: const [4, 2],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(15),
                            child: SizedBox(
                              height: 200,
                              width: 125,
                              child: Center(child: SizedBox.shrink()),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 390,
                          left: 70,
                          child: Container(
                            height: 225,
                            width: 110,
                            decoration: BoxDecoration(
                              color: AppColors.splashBackground,
                            ),
                          ),
                        ),
                        Positioned(
                          //chapter 4
                          top: 375,
                          left: 75,
                          child: Container(
                            height: 70,
                            width: 100,
                            alignment: Alignment.center,
                            color: AppColors.splashBackground,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.course == null) {
                                  context.showErrorToast(
                                    "Silahkan pilih course terlebih dahulu sebelum memulai",
                                  );
                                  return;
                                }
                                final chapterId =
                                    chapterState.courseChapter[4].chapterId;

                                if (chapterStatus[4] == "lock") {
                                  if (chapterStatus[3] != "done") {
                                    context.showErrorToast(
                                      "Selesaikan dahulu course sebelumnya",
                                    );
                                    return;
                                  }
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.showSuccessToast(
                                    "Course telah berhasil dibuka",
                                  );
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.read<ChapterCubit>().getAllChapters(
                                    widget.course!.courseId,
                                  );
                                  context
                                      .read<FinishedChapterAndModuleCubit>()
                                      .getFinishedChapters(
                                        widget.course?.courseId ?? "",
                                      );
                                  return;
                                }
                                if (chapterStatus[4] == "onprogres") {
                                  AppNavigator.push(
                                    context,
                                    BlocProvider.value(
                                      value: context.read<BottomNavCubit>(),
                                      child: SubchapterPage(
                                        courseId: widget.course!.courseId,
                                        chapterOrder: 4,
                                        isChapterZero: widget.isChapterZero,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              },
                              child: Container(
                                height: 45,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: chapterStatus[4] == "onprogres"
                                      ? Border.symmetric(
                                          vertical: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                          horizontal: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: chapterStatus[4] == "onprogres"
                                      ? Text(
                                          "Bab 4",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : chapterStatus[4] == "lock"
                                      ? lock()
                                      : Center(
                                          child: Icon(Icons.check, size: 50),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          //chapter 5
                          top: 475,
                          left: -50,
                          child: Container(
                            height: 70,
                            width: 100,
                            alignment: Alignment.center,
                            color: AppColors.splashBackground,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.course == null) {
                                  context.showErrorToast(
                                    "Silahkan pilih course terlebih dahulu sebelum memulai",
                                  );
                                  return;
                                }
                                final chapterId =
                                    chapterState.courseChapter[5].chapterId;

                                if (chapterStatus[5] == "lock") {
                                  if (chapterStatus[4] != "done") {
                                    context.showErrorToast(
                                      "Selesaikan dahulu course sebelumnya",
                                    );
                                    return;
                                  }
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.showSuccessToast(
                                    "Course telah berhasil dibuka",
                                  );
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.read<ChapterCubit>().getAllChapters(
                                    widget.course!.courseId,
                                  );
                                  context
                                      .read<FinishedChapterAndModuleCubit>()
                                      .getFinishedChapters(
                                        widget.course?.courseId ?? "",
                                      );
                                  return;
                                }
                                if (chapterStatus[5] == "onprogres") {
                                  AppNavigator.push(
                                    context,
                                    BlocProvider.value(
                                      value: context.read<BottomNavCubit>(),
                                      child: SubchapterPage(
                                        courseId: widget.course!.courseId,
                                        chapterOrder: 5,
                                        isChapterZero: widget.isChapterZero,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              },
                              child: Container(
                                height: 45,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: chapterStatus[5] == "onprogres"
                                      ? Border.symmetric(
                                          vertical: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                          horizontal: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: chapterStatus[5] == "onprogres"
                                      ? Text(
                                          "Bab 5",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : chapterStatus[5] == "lock"
                                      ? lock()
                                      : Center(
                                          child: Icon(Icons.check, size: 50),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 620,
                          left: 125,
                          child: DottedBorder(
                            color: const Color.fromARGB(255, 184, 184, 184),
                            strokeWidth: 2,
                            dashPattern: const [4, 2],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(0),
                            child: SizedBox(width: 50, height: 65),
                          ),
                        ),
                        Positioned(
                          top: 618,
                          left: 126,
                          child: Container(
                            height: 75,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppColors.splashBackground,
                            ),
                          ),
                        ),
                        Positioned(
                          //chapter 6
                          top: 580,
                          left: 75,
                          child: Container(
                            height: 70,
                            width: 100,
                            alignment: Alignment.center,
                            color: AppColors.splashBackground,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.course == null) {
                                  context.showErrorToast(
                                    "Silahkan pilih course terlebih dahulu sebelum memulai",
                                  );
                                  return;
                                }
                                final chapterId =
                                    chapterState.courseChapter[6].chapterId;

                                if (chapterStatus[6] == "lock") {
                                  if (chapterStatus[5] != "done") {
                                    context.showErrorToast(
                                      "Selesaikan dahulu course sebelumnya",
                                    );
                                    return;
                                  }
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.showSuccessToast(
                                    "Course telah berhasil dibuka",
                                  );
                                  context.read<QuizCubit>().addOnprogresChapter(
                                    chapterId,
                                  );
                                  context.read<ChapterCubit>().getAllChapters(
                                    widget.course!.courseId,
                                  );
                                  context
                                      .read<FinishedChapterAndModuleCubit>()
                                      .getFinishedChapters(
                                        widget.course?.courseId ?? "",
                                      );
                                  return;
                                }
                                if (chapterStatus[6] == "onprogres") {
                                  AppNavigator.push(
                                    context,
                                    BlocProvider.value(
                                      value: context.read<BottomNavCubit>(),
                                      child: SubchapterPage(
                                        courseId: widget.course!.courseId,
                                        chapterOrder: 6,
                                        isChapterZero: widget.isChapterZero,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              },
                              child: Container(
                                height: 45,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: chapterStatus[6] == "onprogres"
                                      ? Border.symmetric(
                                          vertical: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                          horizontal: BorderSide(
                                            color: Color(0XFF4348DE),
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: chapterStatus[6] == "onprogres"
                                      ? Text(
                                          "Bab 6",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'JetBrainsMono',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : chapterStatus[6] == "lock"
                                      ? lock()
                                      : Center(
                                          child: Icon(Icons.check, size: 50),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return Expanded(
            child: Center(
              child: Text(
                "Course ini masih belum memiliki chapter",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondaryBackgroundButton,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget lock() {
    return Container(
      height: 45,
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.symmetric(
          vertical: BorderSide(color: AppColors.secondaryText, width: 4),
          horizontal: BorderSide(color: AppColors.secondaryText, width: 4),
        ),
        color: Colors.grey,
      ),
      child: Center(child: Icon(Icons.lock)),
    );
  }

  void generateChapterStatus(
    List<CourseChapterEntity> chapters,
    List<String> finished,
    String onProgres,
  ) {
    chapterStatus = chapters.map((chapter) {
      if (finished.contains(chapter.chapterId)) {
        return "done";
      } else if (onProgres == chapter.chapterId) {
        return "onprogres";
      } else {
        return "lock";
      }
    }).toList();
  }
}
