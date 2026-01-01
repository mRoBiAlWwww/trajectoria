import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/date/date_convert.dart';
import 'package:trajectoria/common/widgets/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/competiton_feature_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/competition_result.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/widgets/upload_file.dart';

class DetailCompetitionPage extends StatelessWidget {
  final CompetitionEntity competition;
  const DetailCompetitionPage({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SubmissionCubit()..isAlreadySubmitted(competition.competitionId),
        ),
        BlocProvider(
          create: (context) =>
              SearchCompeteCubit()
                ..getSingleCompetitionAndSubmission(competition.competitionId),
        ),
        BlocProvider(create: (context) => CompetitonFeatureCubit()),
      ],
      child: _DetailCompetitionContent(competition: competition),
    );
  }
}

class _DetailCompetitionContent extends StatefulWidget {
  final CompetitionEntity competition;
  const _DetailCompetitionContent({required this.competition});

  @override
  State<_DetailCompetitionContent> createState() =>
      _DetailCompetitionContentState();
}

class _DetailCompetitionContentState extends State<_DetailCompetitionContent> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  String buttonText = "Daftar Sekarang";
  bool isLoading = false;
  bool isAdded = false;
  bool _isMaximized = false;
  bool bookmarkStatus = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final currentSize = _controller.size;
      if (currentSize >= 0.99 && !_isMaximized) {
        setState(() => _isMaximized = true);
      } else if (currentSize < 0.99 && _isMaximized) {
        setState(() => _isMaximized = false);
      }
      if (_controller.size < 0.55) {
        _controller.jumpTo(0.55);
      }
    });

    _checkInitialBookmarkStatus();
  }

  Future<void> _checkInitialBookmarkStatus() async {
    final bool isBookmarked = await context
        .read<CompetitonFeatureCubit>()
        .isBookmark(widget.competition.competitionId);
    setState(() {
      bookmarkStatus = isBookmarked;
    });
  }

  void _onBookmarkTapped(BuildContext context, bool status) {
    setState(() {
      bookmarkStatus = status;
    });

    if (status) {
      context.read<CompetitonFeatureCubit>().addBookmark(
        widget.competition.competitionId,
      );
    } else {
      context.read<CompetitonFeatureCubit>().deleteBookmark(
        widget.competition.competitionId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //formatter date
    final formattedDate = widget.competition.deadline.toShortDate();

    final screenSize = MediaQuery.of(context).size;
    final double bottomSafeAreaPadding = MediaQuery.of(context).padding.bottom;

    return BlocBuilder<SubmissionCubit, SubmissionState>(
      builder: (context, submissionState) {
        if (submissionState is SubmissionLoading) {
          isLoading = true;
        } else {
          if (submissionState is OnprogresSubmited) {
            buttonText = "Unggah Submission";
            isAdded = true;
          } else if (submissionState is DoneSubmited) {
            buttonText = "Submission Terunggah";
            isAdded = true;
          }
          isLoading = false;
        }
        return Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.competition.competitionImage,
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                width: screenSize.width,
                height: screenSize.height * 0.5,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: screenSize.height * 0.5,
                        ),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: 20,
              left: 15,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 30.0,
                icon: SvgPicture.asset(
                  AppVectors.close,
                  width: 40.0,
                  height: 40.0,
                ),
              ),
            ),
            DraggableScrollableSheet(
              controller: _controller,
              initialChildSize: 0.6,
              minChildSize: 0.6,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Material(
                          color: AppColors.splashBackground,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  50,
                                  20,
                                  10,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        widget.competition.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    _isMaximized
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                _controller.animateTo(
                                                  0.55,
                                                  duration: const Duration(
                                                    milliseconds: 400,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                );
                                              },
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 150),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    child: Image.network(
                                                      widget
                                                          .competition
                                                          .companyProfileImage,
                                                      width: 25,
                                                      height: 25,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    widget
                                                        .competition
                                                        .companyName,
                                                    style: TextStyle(
                                                      fontFamily: "Inter",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .secondaryText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                alignment: AlignmentGeometry
                                                    .centerRight,
                                                child: IconButton(
                                                  onPressed: () {
                                                    _onBookmarkTapped(
                                                      context,
                                                      !bookmarkStatus,
                                                    );
                                                  },
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  iconSize: 30.0,
                                                  icon: Icon(
                                                    bookmarkStatus
                                                        ? Icons.bookmark
                                                        : Icons.bookmark_border,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Deadline",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              const DottedLine(
                                                dashGapLength: 0,
                                                lineThickness: 1,
                                                dashColor: Color.fromARGB(
                                                  255,
                                                  236,
                                                  236,
                                                  233,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                formattedDate,
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.positiveColor,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Rewards",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              const DottedLine(
                                                dashGapLength: 0,
                                                lineThickness: 1,
                                                dashColor: Color.fromARGB(
                                                  255,
                                                  236,
                                                  236,
                                                  233,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                widget
                                                    .competition
                                                    .rewardDescription,
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.secondaryText,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Jenis Pengumpulan",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              const DottedLine(
                                                dashGapLength: 0,
                                                lineThickness: 1,
                                                dashColor: Color.fromARGB(
                                                  255,
                                                  236,
                                                  236,
                                                  233,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                widget
                                                    .competition
                                                    .submissionType,
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.secondaryText,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "Problem Statement",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              const DottedLine(
                                                dashGapLength: 0,
                                                lineThickness: 1,
                                                dashColor: Color.fromARGB(
                                                  255,
                                                  236,
                                                  236,
                                                  233,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                widget
                                                    .competition
                                                    .problemStatement,
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.secondaryText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        if (isAdded)
                                          ListView.builder(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: widget
                                                .competition
                                                .guidebook
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                    ),
                                                child: InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<SubmissionCubit>()
                                                        .downloadAndOpenFile(
                                                          widget
                                                              .competition
                                                              .guidebook[index]
                                                              .url,
                                                          'trajectory_competition_rules.pdf',
                                                        );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 15,
                                                          vertical: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.white,
                                                          const Color.fromARGB(
                                                            255,
                                                            248,
                                                            226,
                                                            224,
                                                          ), // warna bawah
                                                        ],
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.red,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .picture_as_pdf_rounded,
                                                          color: Colors.red,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          widget
                                                              .competition
                                                              .guidebook[index]
                                                              .fileName,
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        SizedBox(
                                          height:
                                              70 + 15 + bottomSafeAreaPadding,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  BlocBuilder<SearchCompeteCubit, SearchCompeteState>(
                    builder: (context, searchState) {
                      if (searchState is SingleCompeteAndSubmissionLoaded) {
                        final submission = searchState.submission;
                        final competition = searchState.competition;
                        final totalParticipant =
                            searchState.totalCompetitionParticipants;
                        if (submission != null) {
                          return Material(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  //icon papan
                                  submission.isChecked
                                      ? Icon(
                                          CupertinoIcons.doc_checkmark_fill,
                                          size: 40,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.checklist_outlined,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                  //text
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        submission.isChecked
                                            ? "Penilaian selesai!"
                                            : "Sedang dalam proses penilaian",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        submission.isChecked
                                            ? "Penilaian selesai!"
                                            : "Penilaian sedang berlangsung",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      submission.isChecked
                                          ? SizedBox.shrink()
                                          : Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF87B7B7),
                                                    Color(0xFFC7E8E8),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                              ),
                                              child: Text(
                                                "${countdown(competition.deadline)} Hari lagi",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  submission.isChecked
                                      ? Row(
                                          children: [
                                            SizedBox(width: 12),
                                            BasicAppButton(
                                              onPressed: () {
                                                AppNavigator.push(
                                                  context,
                                                  CompetitionResultPage(
                                                    submission: submission,
                                                    competition: competition,
                                                    totalParticipant:
                                                        totalParticipant,
                                                  ),
                                                );
                                              },
                                              verticalPadding: 15,
                                              horizontalPadding: 50,
                                              backgroundColor: AppColors
                                                  .secondaryBackgroundButton,
                                              content: Text(
                                                "Lihat",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Container(
                    color: Colors.white,
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        height: 90,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: BasicAppButton(
                            onPressed: () {
                              if (submissionState is SubmissionInitial) {
                                context
                                    .read<SubmissionCubit>()
                                    .addCompetitionParticipant(
                                      widget.competition.competitionId,
                                    );
                              }
                              if (submissionState is OnprogresSubmited) {
                                AppBottomsheet.display(
                                  context,
                                  BlocProvider.value(
                                    value: context.read<SubmissionCubit>(),
                                    child: UploadSheetContent(
                                      problemStatement:
                                          widget.competition.problemStatement,
                                      competitionParticipantId: submissionState
                                          .competitionParticipantId,
                                      competitiondId:
                                          widget.competition.competitionId,
                                    ),
                                  ),
                                );
                              }
                            },
                            verticalPadding: 0,
                            backgroundColor: submissionState is DoneSubmited
                                ? AppColors.disableBackgroundButton
                                : AppColors.secondaryBackgroundButton,
                            content: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    buttonText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: submissionState is DoneSubmited
                                          ? AppColors.disableTextButton
                                          : Colors.white,
                                    ),
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
        );
      },
    );
  }

  int countdown(Timestamp deadline) {
    final now = DateTime.now();
    final deadlineDate = deadline.toDate();
    final difference = deadlineDate.difference(now);
    return difference.inDays;
  }
}
