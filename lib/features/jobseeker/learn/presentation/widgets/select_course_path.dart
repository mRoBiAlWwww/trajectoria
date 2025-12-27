import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/course_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/course_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_course_cubit.dart';

class SelectCourseSheetContent extends StatelessWidget {
  const SelectCourseSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseCubit()..getCourses(),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Pilih Jalur",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    // optional: bisa Flexible atau langsung ListView
                    child: BlocBuilder<CourseCubit, CourseState>(
                      builder: (context, state) {
                        if (state is CourseLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is CourseLoaded) {
                          return ListView.builder(
                            itemCount: state.course.length,
                            itemBuilder: (context, index) {
                              int progress = 0;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<HydratedSelectedCourseCubit>()
                                        .setCourse(state.course[index]);
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.course[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'JetBrainsMono',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Container(
                                              width: double.infinity,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .thirdBackGroundButton,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  2.0,
                                                ),
                                                child: FractionallySizedBox(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  widthFactor: progress / 100,
                                                  child: Container(
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      gradient: LinearGradient(
                                                        begin: Alignment
                                                            .bottomCenter,
                                                        end:
                                                            Alignment.topCenter,
                                                        colors: [
                                                          Color(0xFFB2B2B2),
                                                          Color(0xFF242424),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "${progress.toString()}%",
                                              style: TextStyle(
                                                fontFamily: 'JetBrainsMono',
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 15,
              right: 10,
              child: IconButton(
                icon: SvgPicture.asset(AppVectors.close, width: 40, height: 40),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
