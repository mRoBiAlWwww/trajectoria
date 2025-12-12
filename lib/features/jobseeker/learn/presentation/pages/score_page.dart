import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/quiz_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/widgets/gift.dart';

class ScorePage extends StatefulWidget {
  final double? finalScore;
  final String nextModule;
  final String badge;
  final int maximumScore;
  final int nextMaximumScore;
  const ScorePage({
    super.key,
    required this.finalScore,
    required this.nextModule,
    required this.badge,
    required this.nextMaximumScore,
    required this.maximumScore,
  });

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  bool showFirst = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showFirst = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit(),
      child: Scaffold(
        body: showFirst
            ? ScoreGift()
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 25,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            AppVectors.finalScore,
                            width: 200.0,
                            height: 200.0,
                          ),
                          Text(
                            "${widget.finalScore!.truncate()} / ${widget.maximumScore} XP",
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Pelajaran Selesai!",
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Selesaikan pelajaran berikutnya untuk mendapatkan",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.disableTextButton,
                            ),
                          ),
                          Text(
                            "badge “${widget.badge}”",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.disableTextButton,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 100),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.thirdBackGroundButton,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25,
                          ),
                          child: widget.nextModule == ""
                              ? Text(
                                  "Selamat anda telah menyelesaikan sub chapter ini",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Materi Selanjutnya:",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              widget.nextModule,
                                              style: TextStyle(
                                                fontFamily: 'JetBrainsMono',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        child: VerticalDivider(
                                          width: 1,
                                          thickness: 1,
                                          color:
                                              AppColors.disableBackgroundButton,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "KAMU DAPAT",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            Text(
                                              "${widget.nextMaximumScore} XP",
                                              style: TextStyle(
                                                fontFamily: 'JetBrainsMono',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: showFirst
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: BasicAppButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Lanjut",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
      ),
    );
  }
}
