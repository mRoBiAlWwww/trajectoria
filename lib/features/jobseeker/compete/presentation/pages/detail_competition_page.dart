import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:trajectoria/common/helper/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/hydrated_history_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/widgets/upload_file.dart';

class DetailCompetitionPage extends StatefulWidget {
  final CompetitionEntity competition;
  const DetailCompetitionPage({super.key, required this.competition});

  @override
  State<DetailCompetitionPage> createState() => _DetailCompetitionPageState();
}

class _DetailCompetitionPageState extends State<DetailCompetitionPage> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  String buttonText = "Daftar Sekarang";
  bool isLoading = false;
  bool isAdded = false;
  bool _isMaximized = false;

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
  }

  @override
  Widget build(BuildContext context) {
    final DateTime deadlineDate = widget.competition.deadline.toDate();
    final String formattedDate = DateFormat(
      'd MMM y',
      'id_ID',
    ).format(deadlineDate);
    final screenSize = MediaQuery.of(context).size;
    final double bottomSafeAreaPadding = MediaQuery.of(context).padding.bottom;
    context.read<HydratedHistoryCubit>().addCompetition(widget.competition);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SubmissionCubit()
                ..isAlreadySubmitted(widget.competition.competitionId),
        ),
        BlocProvider(
          create: (context) =>
              SearchCompeteCubit()
                ..getSingleCompetition(widget.competition.competitionId),
        ),
      ],
      child: BlocBuilder<SubmissionCubit, SubmissionState>(
        builder: (context, state) {
          if (state is SubmissionLoading) {
            isLoading = true;
          } else {
            if (state is OnprogressSubmited) {
              buttonText = "Unggah Submission";
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      padding: const EdgeInsets.only(
                                        bottom: 150,
                                      ),
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
                                                Text(
                                                  widget
                                                      .competition
                                                      .companyName,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Inter",
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.secondaryText,
                                                  ),
                                                ),
                                                SizedBox(height: 30),
                                                Text(
                                                  "Deadline",
                                                  style: TextStyle(
                                                    fontSize: 14,
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
                                                    fontSize: 14,
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
                                                    fontSize: 14,
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
                                                    fontSize: 14,
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
                                                    fontSize: 14,
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
                                                    fontSize: 14,
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
                                                    fontSize: 14,
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
                                                    fontSize: 14,
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
                                                          .read<
                                                            SubmissionCubit
                                                          >()
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
                                                          begin: Alignment
                                                              .topCenter,
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
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors.red,
                                                              fontSize: 14,
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
                child: Container(
                  color: Colors.white,
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      height: 90,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        child: state is DoneSubmited
                            ? SizedBox(
                                width: double.infinity,
                                child: Image.asset(
                                  AppImages.doneSubmission,
                                  fit: BoxFit.fitWidth,
                                ),
                              )
                            : BasicAppButton(
                                onPressed: () {
                                  debugPrint(state.toString());
                                  if (state is SubmissionInitial) {
                                    debugPrint("=======f=====");
                                    context
                                        .read<SubmissionCubit>()
                                        .addCompetitionParticipant(
                                          widget.competition.competitionId,
                                        );
                                  }
                                  if (state is OnprogressSubmited) {
                                    debugPrint("=======g=====");
                                    AppBottomsheet.display(
                                      context,
                                      BlocProvider.value(
                                        value: context.read<SubmissionCubit>(),
                                        child: UploadSheetContent(
                                          problemStatement: widget
                                              .competition
                                              .problemStatement,
                                          competitionParicipantId:
                                              state.competitionParticipantId,
                                          competitiondId:
                                              widget.competition.competitionId,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                backgroundColor:
                                    AppColors.secondaryBackgroundButton,
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
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Opsional: "Drag Handle"
                                      // Container(
                                      //   width: 40,
                                      //   height: 5,
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.grey.shade300,
                                      //     borderRadius: BorderRadius.circular(
                                      //       12,
                                      //     ),
                                      //   ),
                                      // ),
// DraggableScrollableSheet(
//                 controller: _controller,
//                 initialChildSize: 0.6,
//                 minChildSize: 0.6,
//                 maxChildSize: 1,
//                 builder: (context, scrollController) {
//                   return LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Stack(
//                         children: [
//                           Material(
//                             color: AppColors.splashBackground,
//                             borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(20),
//                             ),
//                             child: ConstrainedBox(
//                               constraints: BoxConstraints(
//                                 minHeight: constraints.maxHeight,
//                               ),
//                               child: SingleChildScrollView(
//                                 controller: scrollController,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 150),
//                                   child: Column(
//                                     children: [
//                                       SizedBox(height: 50),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 30,
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.stretch,
//                                           children: [
//                                             _isMaximized
//                                                 ? Row(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Expanded(
//                                                         flex: 10,
//                                                         child: Text(
//                                                           widget
//                                                               .competition
//                                                               .title,
//                                                           style: TextStyle(
//                                                             fontSize: 25,
//                                                             fontFamily: "Inter",
//                                                             fontWeight:
//                                                                 FontWeight.w700,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Expanded(
//                                                         flex: 1,
//                                                         child: IconButton(
//                                                           padding:
//                                                               EdgeInsets.zero,
//                                                           icon: const Icon(
//                                                             Icons.close,
//                                                             color: Colors.black,
//                                                             size: 30,
//                                                           ),
//                                                           onPressed: () {
//                                                             _controller.animateTo(
//                                                               0.55,
//                                                               duration:
//                                                                   const Duration(
//                                                                     milliseconds:
//                                                                         400,
//                                                                   ),
//                                                               curve: Curves
//                                                                   .easeInOut,
//                                                             );
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   )
//                                                 : Text(
//                                                     widget.competition.title,
//                                                     style: TextStyle(
//                                                       fontSize: 25,
//                                                       fontFamily: "Inter",
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                     ),
//                                                   ),
//                                             SizedBox(height: 10),
//                                             Row(
//                                               children: [
//                                                 Image.asset(
//                                                   AppImages.hology,
//                                                   width: 25,
//                                                   height: 25,
//                                                 ),
//                                                 SizedBox(width: 10),
//                                                 Text(
//                                                   "PT Hology Inovation",
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontFamily: "Inter",
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                         AppColors.secondaryText,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(height: 30),
//                                             Text(
//                                               "Deadline",
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: "Inter",
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             const DottedLine(
//                                               dashGapLength: 0,
//                                               lineThickness: 1,
//                                               dashColor: Color.fromARGB(
//                                                 255,
//                                                 236,
//                                                 236,
//                                                 233,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             Text(
//                                               formattedDate,
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: "Inter",
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.cyan,
//                                               ),
//                                             ),
//                                             SizedBox(height: 30),
//                                             Text(
//                                               "Rewards",
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: "Inter",
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             const DottedLine(
//                                               dashGapLength: 0,
//                                               lineThickness: 1,
//                                               dashColor: Color.fromARGB(
//                                                 255,
//                                                 236,
//                                                 236,
//                                                 233,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             Text(
//                                               widget
//                                                   .competition
//                                                   .rewardDescription,
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: "Inter",
//                                                 fontWeight: FontWeight.w500,
//                                                 color: AppColors.secondaryText,
//                                               ),
//                                             ),
//                                             SizedBox(height: 30),
//                                             Text(
//                                               "Jenis Pengumpulan",
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: "Inter",
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             const DottedLine(
//                                               dashGapLength: 0,
//                                               lineThickness: 1,
//                                               dashColor: Color.fromARGB(
//                                                 255,
//                                                 236,
//                                                 236,
//                                                 233,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             Text(
//                                               widget.competition.submissionType,
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: "Inter",
//                                                 fontWeight: FontWeight.w500,
//                                                 color: AppColors.secondaryText,
//                                               ),
//                                             ),
//                                             SizedBox(height: 30),
//                                             Text(
//                                               "Problem Statement",
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: "Inter",
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             const DottedLine(
//                                               dashGapLength: 0,
//                                               lineThickness: 1,
//                                               dashColor: Color.fromARGB(
//                                                 255,
//                                                 236,
//                                                 236,
//                                                 233,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             Text(
//                                               widget
//                                                   .competition
//                                                   .problemStatement,
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontFamily: "Inter",
//                                                 fontWeight: FontWeight.w500,
//                                                 color: AppColors.secondaryText,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(height: 30),
//                                       if (isAdded)
//                                         ListView.builder(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: 30,
//                                           ),
//                                           shrinkWrap: true,
//                                           physics:
//                                               const NeverScrollableScrollPhysics(),
//                                           itemCount: widget
//                                               .competition
//                                               .guidebook
//                                               .length,
//                                           itemBuilder: (context, index) {
//                                             return Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     vertical: 5,
//                                                   ),
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   context
//                                                       .read<CompetitionCubit>()
//                                                       .downloadAndOpenFile(
//                                                         widget
//                                                             .competition
//                                                             .guidebook[index]
//                                                             .url,
//                                                         'trajectory_competition_rules.pdf',
//                                                       );
//                                                 },
//                                                 child: Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: 15,
//                                                     vertical: 10,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     gradient: LinearGradient(
//                                                       begin: Alignment
//                                                           .topCenter, // titik awal (atas)
//                                                       end: Alignment
//                                                           .bottomCenter, // titik akhir (bawah)
//                                                       colors: [
//                                                         Colors
//                                                             .white, // warna atas
//                                                         const Color.fromARGB(
//                                                           255,
//                                                           248,
//                                                           226,
//                                                           224,
//                                                         ), // warna bawah
//                                                       ],
//                                                     ),
//                                                     border: Border.all(
//                                                       color: Colors.red,
//                                                       width: 1,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           12,
//                                                         ), // sudut melengkung
//                                                   ),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Icon(
//                                                         Icons
//                                                             .picture_as_pdf_rounded,
//                                                         color: Colors.red,
//                                                       ),
//                                                       SizedBox(width: 10),
//                                                       Text(
//                                                         widget
//                                                             .competition
//                                                             .guidebook[index]
//                                                             .title,
//                                                         style: TextStyle(
//                                                           fontFamily: 'Inter',
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           color: Colors.red,
//                                                           fontSize: 18,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       SizedBox(
//                                         height: 70 + 15 + bottomSafeAreaPadding,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
              