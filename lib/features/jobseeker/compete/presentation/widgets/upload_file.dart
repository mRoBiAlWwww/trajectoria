import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:trajectoria/common/widgets/bottomsheets/app_bottom_sheets.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/widgets/submit.dart';

class UploadSheetContent extends StatefulWidget {
  final String competitionParticipantId;
  final String competitiondId;
  final String problemStatement;

  const UploadSheetContent({
    super.key,
    required this.competitionParticipantId,
    required this.competitiondId,
    required this.problemStatement,
  });

  @override
  State<UploadSheetContent> createState() => _UploadSheetContentState();
}

class _UploadSheetContentState extends State<UploadSheetContent> {
  final TextEditingController _uploadText = TextEditingController();

  List<FileItemEntity> filesUrl = [];

  @override
  void initState() {
    super.initState();
    _uploadText.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _uploadText.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _addNewfilesUrl(List<FileItemEntity> newUrl) {
    setState(() {
      filesUrl.addAll(newUrl);
    });
  }

  void _removeFileUrlAtIndex(int index) {
    setState(() {
      filesUrl.removeAt(index);
    });
  }

  void _openSecondSheet(BuildContext context) {
    AppBottomsheet.display(
      context,
      BlocProvider.value(
        value: context.read<SubmissionCubit>(),
        child: SubmitSheetContent(
          problemStatement: widget.problemStatement,
          competitionParticipantId: widget.competitionParticipantId,
          competitionId: widget.competitiondId,
          textField: _uploadText.text,
          filesUrl: filesUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid =
        _uploadText.text.trim().isNotEmpty || filesUrl.isNotEmpty;
    return BlocProvider(
      create: (context) => SubmissionCubit(),
      child: Builder(
        builder: (builderContext) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(height: 25),
                        Image.asset(AppImages.profile, width: 60, height: 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "Unggah Submission",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        _uploadTextField(),
                        SizedBox(height: 25),
                        BlocListener<SubmissionCubit, SubmissionState>(
                          listener: (context, state) {
                            if (state is SuccessUpload) {
                              _addNewfilesUrl(state.files);
                            }
                            if (state is SubmissionError) {
                              _displayErrorToast(context, state.message);
                            }
                          },
                          child: const SizedBox.shrink(),
                        ),
                        filesUrl.isEmpty
                            ? BlocBuilder<SubmissionCubit, SubmissionState>(
                                builder: (context, state) {
                                  if (state is SubmissionLoading) {
                                    return Center(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 80),
                                          CircularProgressIndicator(
                                            color: Colors.teal,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Center(
                                    child: _buildUploadButton(builderContext),
                                  );
                                },
                              )
                            : Expanded(child: _buildFilesList(builderContext)),
                      ],
                    ),
                  ),
                  // Tombol "Tambah"
                  if (filesUrl.isNotEmpty)
                    Positioned(
                      bottom: 120,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: BlocBuilder<SubmissionCubit, SubmissionState>(
                          builder: (context, state) {
                            final bool isLoading = state is SubmissionLoading;
                            return InkWell(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      builderContext
                                          .read<SubmissionCubit>()
                                          .uploadFilesSubmissions();
                                    },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.teal,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: isLoading
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.teal,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.teal,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Tambah File",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.teal,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  Positioned(
                    top: 5,
                    right: 5,
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
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: BasicAppButton(
                        onPressed: isValid
                            ? () {
                                _openSecondSheet(context);
                              }
                            : null,
                        backgroundColor: Colors.black,
                        content: Text(
                          "Unggah",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _uploadTextField() {
    final OutlineInputBorder customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 184, 184, 184),
        width: 2.0,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: _uploadText,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 3,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText:
              "Kamu bisa unggah file submission yang berupa link disini...",
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
          hintMaxLines: 3,

          enabledBorder: customBorder,
          focusedBorder: customBorder,
          border: customBorder,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 15.0,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DottedBorder(
        color: const Color.fromARGB(255, 184, 184, 184),
        strokeWidth: 2,
        dashPattern: const [15, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          constraints: const BoxConstraints(minHeight: 180, maxHeight: 180),
          width: double.infinity,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 180),
            child: Center(
              child: InkWell(
                onTap: () {
                  context.read<SubmissionCubit>().uploadFilesSubmissions();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insert_drive_file_rounded,
                      color: AppColors.disableTextButton,
                      size: 28,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Unggah Disini",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilesList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 180),
      shrinkWrap: true,
      itemCount: filesUrl.length,
      itemBuilder: (context, index) {
        final colorExtension = getFileColor(filesUrl[index].extension);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: InkWell(
            onTap: () {
              context.read<SubmissionCubit>().downloadAndOpenFile(
                filesUrl[index].url,
                'trajectory_competition_rules.pdf',
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: colorExtension, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.picture_as_pdf_rounded,
                          color: colorExtension,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            filesUrl[index].fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: colorExtension,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _removeFileUrlAtIndex(index);
                    },
                    child: Icon(Icons.close, size: 20, color: colorExtension),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color getFileColor(String extension) {
    final String cleanInput = extension.trim().toLowerCase();

    switch (cleanInput) {
      case 'pdf':
        return Colors.red;

      case 'docs':
      case 'doc':
      case 'docx':
        return Colors.blue;

      case 'zip':
        return Colors.grey;

      default:
        return Colors.black;
    }
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
