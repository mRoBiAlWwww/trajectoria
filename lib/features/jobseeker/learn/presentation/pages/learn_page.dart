import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:trajectoria/common/bloc/navigation/bottom_navigation_cubit.dart';
import 'package:trajectoria/common/helper/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/course.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/course_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_course_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_progress_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_progress_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/pages/subchapter_page.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/widgets/select_course_path.dart';
import 'package:trajectoria/main.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with RouteAware {
  bool isExpanded = false;
  CourseEntity? course;
  String? titleToShow;

  JobSeekerEntity? jobseeker;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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

    setState(() {
      jobseeker = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    course = context.read<HydratedSelectedCourseCubit>().state;

    titleToShow = course?.title ?? "Pilih Course...";

    return Scaffold(
      body: BlocProvider(
        create: (context) => CourseCubit(),
        child: Builder(
          builder: (context) {
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
                                    titleToShow!,
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
                            //   },
                            // ),
                          ),
                          SizedBox(height: 8),
                          BlocBuilder<
                            HydratedProgressCubit,
                            HydratedProgressState
                          >(
                            builder: (context, progressState) {
                              int progress = context
                                  .read<HydratedProgressCubit>()
                                  .getScoreByCourseId(course?.courseId ?? "");
                              return Container(
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
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                titleToShow!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'JetBrainsMono',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "${progress.toString()}%",
                                              style: TextStyle(
                                                fontFamily: 'JetBrainsMono',
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                foreground: Paint()
                                                  ..shader =
                                                      const LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
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

                                    //
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                              );
                              //   },
                              // );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      _roadMap(context),
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
                        if (course != null) {
                          AppNavigator.push(
                            context,
                            MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<BottomNavCubit>(),
                                ),
                                BlocProvider(
                                  create: (context) => ChapterCubit(),
                                ),
                              ],
                              child: SubchapterPage(
                                courseId: course!.courseId,
                                chapterOrder: 1,
                              ),
                            ),
                          );
                        } else {
                          _displayErrorToast(
                            context,
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

  Widget _roadMap(BuildContext context) {
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
                                    fontSize: 14,
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
                  top: -50,
                  left: 80,
                  child: GestureDetector(
                    onTap: () {
                      if (course != null) {
                        AppNavigator.push(
                          context,
                          MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<BottomNavCubit>(),
                              ),
                              BlocProvider(create: (context) => ChapterCubit()),
                            ],
                            child: SubchapterPage(
                              courseId: course!.courseId,
                              chapterOrder: 0,
                            ),
                          ),
                        );
                      } else {
                        _displayErrorToast(
                          context,
                          "Silahkan pilih course terlebih dahulu sebelum memulai",
                        );
                      }
                    },
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: AppColors.thirdBackGroundButton,
                            width: 6,
                          ),
                          horizontal: BorderSide(
                            color: AppColors.thirdBackGroundButton,
                            width: 8,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(Icons.play_arrow_rounded, size: 50),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 63,
                  left: -50,
                  child: Container(
                    height: 70,
                    width: 100,
                    alignment: Alignment.center,
                    color: AppColors.splashBackground,
                    child: GestureDetector(
                      onTap: () {
                        if (course != null) {
                          AppNavigator.push(
                            context,
                            MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<BottomNavCubit>(),
                                ),
                                BlocProvider(
                                  create: (context) => ChapterCubit(),
                                ),
                              ],
                              child: SubchapterPage(
                                courseId: course!.courseId,
                                chapterOrder: 1,
                              ),
                            ),
                          );
                        } else {
                          _displayErrorToast(
                            context,
                            "Silahkan pilih course terlebih dahulu",
                          );
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.symmetric(
                            vertical: BorderSide(
                              color: Color(0XFF4348DE),
                              width: 4,
                            ),
                            horizontal: BorderSide(
                              color: Color(0XFF4348DE),
                              width: 4,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "Bab 1",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'JetBrainsMono',
                              fontWeight: FontWeight.w700,
                            ),
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
                  top: 270,
                  right: -50,
                  child: Container(
                    height: 70,
                    width: 100,
                    alignment: Alignment.center,
                    color: AppColors.splashBackground,
                    child: lock(),
                  ),
                ),
                Positioned(
                  top: 190,
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
                  top: 170,
                  left: 75,
                  child: Container(
                    height: 70,
                    width: 100,
                    alignment: Alignment.center,
                    color: AppColors.splashBackground,
                    child: lock(),
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
                  top: 375,
                  left: 75,
                  child: Container(
                    height: 70,
                    width: 100,
                    alignment: Alignment.center,
                    color: AppColors.splashBackground,
                    child: lock(),
                  ),
                ),
                Positioned(
                  top: 475,
                  left: -50,
                  child: Container(
                    height: 70,
                    width: 100,
                    alignment: Alignment.center,
                    color: AppColors.splashBackground,
                    child: lock(),
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
                  top: 580,
                  left: 75,
                  child: Container(
                    height: 70,
                    width: 100,
                    alignment: Alignment.center,
                    color: AppColors.splashBackground,
                    child: lock(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

  void _displayErrorToast(context, String message) {
    MotionToast.error(
      title: Text(
        "error",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      description: Text(message, style: TextStyle(color: Colors.white)),
    ).show(context);
  }
}
