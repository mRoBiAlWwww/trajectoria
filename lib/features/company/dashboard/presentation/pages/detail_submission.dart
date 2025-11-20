import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:trajectoria/common/helper/overlay/overlay_ai.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/finalis_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/finalis_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competition_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competitions_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_cubit.dart';

class DetailSubmissionPage extends StatefulWidget {
  final CompetitionEntity competition;
  final SubmissionEntity submission;
  final JobSeekerEntity userListed;
  const DetailSubmissionPage({
    super.key,
    required this.submission,
    required this.competition,
    required this.userListed,
  });

  @override
  State<DetailSubmissionPage> createState() => _DetailSubmissionPageState();
}

class _DetailSubmissionPageState extends State<DetailSubmissionPage> {
  final TextEditingController _catatanController = TextEditingController();
  List<double> sliderValue = [0, 0, 0];
  List<int> bobotList = [];
  List<String> urls = [];

  int multiplyScore(List<double> a, List<int> b) {
    debugPrint(a.length.toString());
    debugPrint(b.length.toString());
    if (a.length != b.length) {
      throw Exception("List harus memiliki panjang yang sama");
    }
    double total = 0;
    for (int i = 0; i < a.length; i++) {
      total += a[i] * b[i] / 100;
    }
    return total.round();
  }

  @override
  void initState() {
    super.initState();
    for (var item in widget.competition.rubrik) {
      bobotList.add(item.bobot);
    }
  }

  @override
  Widget build(BuildContext context) {
    urls = widget.submission.answerFiles.map((file) => file.url).toList();
    final DateTime deadlineDate = widget.userListed.createdAt.toDate();
    final String formattedDate = DateFormat(
      'd MMM y',
      'id_ID',
    ).format(deadlineDate);
    final DateTime submitted = widget.submission.submittedAt.toDate();
    final String submittedDate = DateFormat(
      'd MMM y',
      'id_ID',
    ).format(submitted);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrganizeCompetitionCubit()),
        BlocProvider(create: (context) => SubmissionCubit()),
        BlocProvider(create: (context) => UserFinalisCubit()),
      ],
      child: Builder(
        builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0.0,
                backgroundColor: AppColors.splashBackground,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  "Detail Unggahan",
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          widget.userListed.profileImage,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('Gagal memuat.'));
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 25,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.thirdBackGroundButton,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userListed.name,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${widget.userListed.email} Bergabung $formattedDate",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.disableTextButton,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: Icon(
                                        Icons
                                            .do_not_disturb_on_total_silence_rounded,
                                        size: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Diunggah pada",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Text(
                                  submittedDate,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.disableTextButton,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Berkas unggahan",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      widget.submission.answerFiles.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          context
                                              .read<SubmissionCubit>()
                                              .downloadAndOpenFile(
                                                widget
                                                    .submission
                                                    .answerFiles[index]
                                                    .url,
                                                'trajectory_competition_rules.pdf',
                                              );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .picture_as_pdf_rounded,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        widget
                                                            .submission
                                                            .answerFiles[index]
                                                            .fileName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.red,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                InkWell(
                                  onTap: () async {
                                    // await sl<CreateCompetitionService>()
                                    //     .requestPermission();
                                    // for (var file
                                    //     in widget
                                    //         .submission
                                    //         .answerFiles) {
                                    //   await sl<CreateCompetitionService>()
                                    //       .downloadFileWithNotification(
                                    //         file.url,
                                    //         file.fileName,
                                    //       );
                                    // }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0XFFB2B2B2),
                                          Color(0xFF242424),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.download,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Unduh berkas",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Beri nilai",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ...List.generate(
                                  widget.competition.rubrik.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget
                                                  .competition
                                                  .rubrik[index]
                                                  .kriteria,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SliderTheme(
                                                    data: SliderThemeData(
                                                      activeTrackColor:
                                                          Colors.teal,
                                                      inactiveTrackColor: AppColors
                                                          .disableBackgroundButton,
                                                      thumbColor: AppColors
                                                          .disableBackgroundButton,
                                                      overlayColor:
                                                          Colors.transparent,
                                                      trackShape:
                                                          const RectangularSliderTrackShape(),
                                                      thumbShape:
                                                          const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                8,
                                                          ),
                                                      overlayShape:
                                                          SliderComponentShape
                                                              .noOverlay,
                                                    ),
                                                    child: Slider(
                                                      value: sliderValue[index],
                                                      min: 0,
                                                      max: 100,
                                                      onChanged: (newValue) {
                                                        setState(
                                                          () =>
                                                              sliderValue[index] =
                                                                  newValue,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: 30,
                                                  child: Text(
                                                    sliderValue[index]
                                                        .toStringAsFixed(0),
                                                    textAlign: TextAlign
                                                        .end, // Rata kanan
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Catatan",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        (AppColors.thirdBackGroundButton),
                                        Color(0xFFD2D2D2),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: TextField(
                                      controller: _catatanController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Insight AI",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                SizedBox(height: 8),
                                DottedBorder(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: AppColors.thirdBackGroundButton,
                                  strokeWidth: 2,
                                  dashPattern: const [15, 4],
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    constraints: const BoxConstraints(
                                      minHeight: 180,
                                      maxHeight: 180,
                                    ),
                                    width: double.infinity,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minHeight: 180,
                                      ),
                                      child:
                                          BlocConsumer<
                                            OrganizeCompetitionCubit,
                                            OrganizeCompetitionState
                                          >(
                                            listener: (context, state) {
                                              if (state
                                                  is OrganizeCompetitionLoading) {
                                                GlobalLoadingAi.show(context);
                                              } else {
                                                GlobalLoadingAi.hide();
                                              }
                                            },
                                            builder: (context, state) {
                                              if (state
                                                  is OrganizeAISummaryLoaded) {
                                                final data = state.data;

                                                return _buildAISummary(
                                                  common: data.commonPattern,
                                                  summary: data.summary,
                                                );
                                              }
                                              if (widget
                                                  .submission
                                                  .aiAnalyzed
                                                  .summary
                                                  .isNotEmpty) {
                                                return _buildAISummary(
                                                  common: widget
                                                      .submission
                                                      .aiAnalyzed
                                                      .commonPattern,
                                                  summary: widget
                                                      .submission
                                                      .aiAnalyzed
                                                      .summary,
                                                );
                                              }

                                              return _buildEmptyAI(context);
                                            },
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              children: [
                                Expanded(
                                  child: BasicAppButton(
                                    onPressed: () {
                                      setState(() {
                                        sliderValue = [0, 0, 0];
                                      });
                                      _catatanController.clear();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    borderRad: 22,
                                    isBordered: true,
                                    borderColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    content: const Text(
                                      "Batal",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: BasicAppButton(
                                    onPressed: () {
                                      context
                                          .read<OrganizeCompetitionCubit>()
                                          .scoring(
                                            multiplyScore(
                                              sliderValue,
                                              bobotList,
                                            ),
                                            _catatanController.text,
                                            widget.submission.submissionId,
                                          );
                                      _displaySuccessToast(
                                        context,
                                        "Berhasil disimpan",
                                      );
                                    },
                                    backgroundColor:
                                        AppColors.thirdPositiveColor,
                                    borderRad: 22,
                                    content: const Center(
                                      child: Text(
                                        "Simpan",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            BlocListener<UserFinalisCubit, UserFinalisState>(
                              listener: (context, finalState) {
                                if (finalState is UserFinalisSuccess) {
                                  if (finalState.success ==
                                      "User sudah ada di final") {
                                    _displayErrorToast(
                                      context,
                                      "User sudah ada di final",
                                    );
                                  } else {
                                    _displaySuccessToast(
                                      context,
                                      "Berhasil ditambahkan",
                                    );
                                  }
                                }

                                if (finalState is UserFinalisFailure) {
                                  _displayErrorToast(
                                    context,
                                    finalState.message,
                                  );
                                }
                              },
                              child:
                                  BlocBuilder<
                                    UserFinalisCubit,
                                    UserFinalisState
                                  >(
                                    builder: (context, finalState) {
                                      return BasicAppButton(
                                        onPressed: () {
                                          context
                                              .read<UserFinalisCubit>()
                                              .addToFinalis(
                                                widget.submission,
                                                widget.userListed.name,
                                                widget.userListed.profileImage,
                                              );
                                        },
                                        borderRad: 22,
                                        backgroundColor: Colors.black,
                                        content: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                AppImages.addFinalis,
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "Tambahkan ke finalis",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
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
          );
        },
      ),
    );
  }

  Widget _buildAISummary({
    required List<String> common,
    required List<String> summary,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),

          Text(
            "Problem Solution",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),

          SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: common.length,
            itemBuilder: (_, i) => _buildBulletText(common[i]),
          ),

          SizedBox(height: 20),
          Text(
            "AI Summary",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),

          SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: summary.length,
            itemBuilder: (_, i) => _buildBulletText(summary[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Belum ada analisis dari AI",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        Text(
          "Tekan tombol di bawah untuk melihat rangkuman otomatis dari submission ini.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            context.read<OrganizeCompetitionCubit>().analyzed(
              widget.submission.submissionId,
              widget.competition.problemStatement,
              urls,
            );
          },
          child: IntrinsicWidth(
            child: Container(
              padding: EdgeInsets.all(10),
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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset(AppImages.blink, width: 20, height: 20),
                  Text(
                    "Analisis",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  void _displaySuccessToast(context, String message) {
    MotionToast.success(
      title: Text(
        "Success",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      description: Text(message, style: TextStyle(color: Colors.white)),
    ).show(context);
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
