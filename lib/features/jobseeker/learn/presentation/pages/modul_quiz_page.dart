import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/module.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/quiz.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_progress.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/modul_or_quiz.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/next_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/quiz_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/quiz_state.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/score_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/pages/score_page.dart';

class ModulQuizPage extends StatefulWidget {
  final ModuleEntity module;
  final int chapterOrder;
  final String nextModule;
  final int nextMaximumScore;
  const ModulQuizPage({
    super.key,
    required this.module,
    required this.chapterOrder,
    required this.nextModule,
    required this.nextMaximumScore,
  });

  @override
  State<ModulQuizPage> createState() => _ModulQuizPageState();
}

class _ModulQuizPageState extends State<ModulQuizPage> {
  int selectedIndex = 100;
  bool isAnswerTrue = false;
  bool _isSubmitting = false;

  void _onOptionTap(int index, int correctAnswer) {
    setState(() {
      selectedIndex = index;
      isAnswerTrue = (index == correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.module.title);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QuizCubit()
            ..getQuizzes(
              widget.module.courseId,
              widget.chapterOrder,
              widget.module.subchapterId,
              widget.module.moduleId,
            ),
        ),
        BlocProvider(create: (context) => ModulOrQuizToggleCubit()),
        BlocProvider(create: (context) => NextCubit()),
        BlocProvider(create: (context) => ScoreCubit()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              centerTitle: true,
              toolbarHeight: 80,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const Icon(
                      Icons.home_filled,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ),
              ],
              title: BlocBuilder<ModulOrQuizToggleCubit, String>(
                builder: (context, state) {
                  Widget buildToggleButton(String label) {
                    final isSelected = state == label;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => context
                            .read<ModulOrQuizToggleCubit>()
                            .select(label),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFB2B2B2),
                                      Color(0xFF242424),
                                    ],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Inter',
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(
                    width: 225,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.disableBackgroundButton,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        buildToggleButton("Modul"),
                        const SizedBox(width: 5),
                        buildToggleButton("Quiz"),
                      ],
                    ),
                  );
                },
              ),
            ),
            body: BlocBuilder<ModulOrQuizToggleCubit, String>(
              builder: (context, state) {
                if (state == "Modul") {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                widget.module.title,
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF87B7B7),
                                      Color(0xFFC7E8E8),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${widget.module.maximumScore.toString()} XP",
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SingleChildScrollView(
                          child: Text(
                            widget.module.content,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state == "Quiz") {
                  return BlocBuilder<QuizCubit, QuizState>(
                    builder: (context, state) {
                      if (state is QuizLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is QuizzesLoaded) {
                        return BlocConsumer<NextCubit, int>(
                          listener: (context, currentIndex) {
                            setState(() {
                              selectedIndex = 100;
                              isAnswerTrue = false;
                            });
                          },
                          builder: (context, currentIndex) {
                            if (currentIndex >= state.quizzes.length) {
                              return const SizedBox.shrink();
                            }
                            final quiz = state.quizzes[currentIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: AppColors.thirdBackGroundButton,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor:
                                            (currentIndex + 1) /
                                            state.quizzes.length,
                                        child: Container(
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
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
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.thirdBackGroundButton,
                                        width: 2,
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white,
                                          Color(0xFFF3F3F3),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 25,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      state.quizzes[currentIndex].questionText,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'JetBrainsMono',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pilih jawaban yang benar",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.disableTextButton,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 4,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child: GestureDetector(
                                              onTap: selectedIndex == 100
                                                  ? () {
                                                      _onOptionTap(
                                                        index,
                                                        quiz.correctAnswer,
                                                      );
                                                    }
                                                  : null,
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: selectedIndex == 100
                                                      ? AppColors
                                                            .thirdBackGroundButton
                                                      : isAnswerTrue &&
                                                            index ==
                                                                quiz.correctAnswer
                                                      ? AppColors.positiveColor
                                                      : !isAnswerTrue &&
                                                            selectedIndex ==
                                                                index
                                                      ? AppColors.negativeColor
                                                      : !isAnswerTrue &&
                                                            quiz.correctAnswer ==
                                                                index
                                                      ? AppColors.positiveColor
                                                      : AppColors
                                                            .thirdBackGroundButton,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.white,
                                                        Color(0xFFF3F3F3),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 20,
                                                        ),
                                                    child: Text(
                                                      getOption(quiz, index),
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .secondaryText,

                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return SizedBox.shrink();
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
            bottomNavigationBar: BlocBuilder<ModulOrQuizToggleCubit, String>(
              builder: (context, state) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: BasicAppButton(
                      // --- LOGIKA onPressed ---
                      onPressed:
                          _isSubmitting // 1. Nonaktifkan jika sedang submit
                          ? null
                          //2. Ketika di section modul kita pindah ke quiz
                          : (state == "Modul"
                                ? () {
                                    context
                                        .read<ModulOrQuizToggleCubit>()
                                        .select("Quiz");
                                  }
                                : (selectedIndex != 100
                                      ? () async {
                                          // 3. Cek jawaban jika benar maka ditambahkan ke score
                                          if (isAnswerTrue) {
                                            context
                                                .read<ScoreCubit>()
                                                .addScore();
                                          }

                                          final int currentScore = context
                                              .read<ScoreCubit>()
                                              .state;
                                          final int currentIndex = context
                                              .read<NextCubit>()
                                              .state;

                                          // 4. Cek apakah ini pertanyaan terakhir (index 4)
                                          if (currentIndex == 4) {
                                            // --- INI ADALAH LOGIKA SUBMIT ---

                                            // 5. Tampilkan loading
                                            setState(() {
                                              _isSubmitting = true;
                                            });

                                            final double finalScore =
                                                (widget.module.maximumScore /
                                                    5) *
                                                currentScore;
                                            debugPrint(
                                              "Mulai submit dengan skor: $finalScore",
                                            );

                                            // 6. Pemanggilan cubit untuk submit data ke DB
                                            await context
                                                .read<QuizCubit>()
                                                .submitQuizAction(
                                                  widget.module.courseId,
                                                  widget.module.chapterId,
                                                  widget.module.subchapterId,
                                                  widget.module.moduleId,
                                                  finalScore,
                                                );
                                            if (context.mounted) {
                                              widget.nextModule == ""
                                                  ? context
                                                        .read<
                                                          HydratedProgressCubit
                                                        >()
                                                        .addItem({
                                                          'courseId': widget
                                                              .module
                                                              .courseId,
                                                          'score': 20,
                                                        })
                                                  : null;
                                            }
                                            debugPrint("Submit ke DB selesai.");

                                            // 7. BARU navigasi SETELAH submit selesai
                                            if (context.mounted) {
                                              debugPrint('gaboleh');
                                              AppNavigator.push(
                                                context,
                                                ScorePage(
                                                  finalScore: finalScore,
                                                  maximumScore: widget
                                                      .module
                                                      .maximumScore,
                                                  nextModule: widget.nextModule,
                                                  nextMaximumScore:
                                                      widget.nextMaximumScore,
                                                ),
                                              );
                                            }
                                            if (mounted) {
                                              setState(() {
                                                _isSubmitting = false;
                                              });
                                            }
                                          } else {
                                            // --- INI ADALAH LOGIKA LANJUT ---
                                            // Bukan pertanyaan terakhir, lanjut seperti biasa
                                            context.read<NextCubit>().next();
                                          }
                                        }
                                      : null)), // Nonaktifkan jika belum memilih
                      isBordered: true,
                      borderColor: Colors.grey,
                      backgroundColor: selectedIndex == 100
                          ? Colors.black
                          : isAnswerTrue
                          ? AppColors.positiveColor
                          : AppColors.negativeColor,
                      content: SizedBox(
                        child: _isSubmitting
                            ? null
                            : Text(
                                context.read<NextCubit>().state == 4
                                    ? "Submit"
                                    : "Lanjut",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String getOption(QuizEntity quiz, int index) {
    switch (index) {
      case 0:
        return quiz.option0;
      case 1:
        return quiz.option1;
      case 2:
        return quiz.option2;
      case 3:
        return quiz.option3;
      default:
        return '';
    }
  }
}
