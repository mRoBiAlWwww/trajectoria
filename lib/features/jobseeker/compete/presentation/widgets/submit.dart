import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/data/models/submission_req.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_cubit.dart';

class SubmitSheetContent extends StatelessWidget {
  final String competitionParticipantId;
  final String competitionId;
  final String problemStatement;
  final List<FileItemEntity> filesUrl;
  final String textField;
  const SubmitSheetContent({
    super.key,
    required this.competitionParticipantId,
    required this.filesUrl,
    required this.textField,
    required this.competitionId,
    required this.problemStatement,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Image.asset(AppImages.profile, width: 65, height: 65),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Kirim Submission Sekarang?",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Setelah dikirim, kamu tidak bisa mengubah file ini. Pastikan file dan deskripsi kamu sudah benar.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.disableTextButton,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: BasicAppButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: AppColors.splashBackground,
                            isBordered: true,
                            borderColor: Colors.black,
                            horizontalPadding: 40,
                            verticalPadding: 10,
                            content: Text(
                              "Batal",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: BasicAppButton(
                            onPressed: () async {
                              await context
                                  .read<SubmissionCubit>()
                                  .addSubmission(
                                    SubmissionReq(
                                      problemStatement: problemStatement,
                                      competitionParticipantId:
                                          competitionParticipantId,
                                      competitionId: competitionId,
                                      answerText: textField,
                                      answerFiles: filesUrl
                                          .map((e) => e.toModel())
                                          .toList(),
                                    ),
                                  );
                              if (context.mounted) {
                                int popCount = 0;
                                Navigator.popUntil(context, (route) {
                                  return ++popCount == 3;
                                });
                              }
                            },
                            backgroundColor: Colors.black,
                            horizontalPadding: 40,
                            verticalPadding: 10,
                            content: Text(
                              "Kirim",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15,
                right: 10,
                child: IconButton(
                  icon: SvgPicture.asset(
                    AppVectors.close,
                    width: 40.0,
                    height: 40.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
