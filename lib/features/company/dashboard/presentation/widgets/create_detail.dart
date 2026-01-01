import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/toast/toast.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/button_next_create_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_comp_image_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_comp_image_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/category.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/submission_state.dart';

class CreateDetailWidget extends StatefulWidget {
  const CreateDetailWidget({super.key});

  @override
  State<CreateDetailWidget> createState() => _CreateDetailWidgetState();
}

class _CreateDetailWidgetState extends State<CreateDetailWidget> {
  List<FileItemEntity> filesUrl = [];
  String imageUrl = '';
  bool isValidDetail = false;
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _problemStatementController =
      TextEditingController();
  final TextEditingController _jenisPengumpulanController =
      TextEditingController();
  CategoryEntity? dropdownValue;

  @override
  void initState() {
    super.initState();
    _judulController.addListener(_onTextChanged);
    _descriptionController.addListener(_onTextChanged);
    _problemStatementController.addListener(_onTextChanged);
    _jenisPengumpulanController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _descriptionController.dispose();
    _problemStatementController.dispose();
    _jenisPengumpulanController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final bool isValid =
        context
            .read<CreateCompetitionCubit>()
            .state
            .competition
            .competitionImage
            .isNotEmpty &&
        _judulController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _problemStatementController.text.trim().isNotEmpty &&
        _jenisPengumpulanController.text.trim().isNotEmpty &&
        filesUrl.isNotEmpty;

    context.read<ButtonNextCreateCubit>().updateValid(isValid);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SubmissionCubit()),
        BlocProvider(create: (context) => CreateCompImageCubit()),
        BlocProvider(
          create: (context) => SearchCompeteCubit()..getCategories(),
        ),
      ],
      child: BlocBuilder<SearchCompeteCubit, SearchCompeteState>(
        builder: (context, categoryState) {
          if (categoryState is SearchCategoriesLoaded) {
            dropdownValue = categoryState.categories.first;
            return BlocBuilder<CreateCompImageCubit, CreateCompImageState>(
              builder: (context, state) {
                final Widget imageContent = _buildImageContent(state);
                if (state is CreateCompImageSuccess) {
                  context.read<CreateCompetitionCubit>().setCompetitionImage(
                    state.url,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Langkah 1 dari 3",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: List.generate(3, (index) {
                        final colors = [
                          Colors.black,
                          AppColors.thirdBackGroundButton,
                          AppColors.thirdBackGroundButton,
                        ];

                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: colors[index],
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 20,
                      ),
                      width: double.infinity,
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
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<CreateCompImageCubit>()
                                          .pickAndUploadImage(
                                            'trajectoria/competition_image',
                                          );
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: AppColors.thirdBackGroundButton,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 75,
                                        color:
                                            AppColors.secondaryBackgroundButton,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: imageContent,
                                    ),
                                  ),
                                  Positioned(
                                    top: 110,
                                    left: 110,
                                    child: FilledButton(
                                      onPressed: () {
                                        context
                                            .read<CreateCompImageCubit>()
                                            .pickAndUploadImage(
                                              'trajectoria/competition_image',
                                            );
                                      },
                                      style: ButtonStyle(
                                        minimumSize: WidgetStateProperty.all(
                                          const Size(0, 0),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              Colors.black,
                                            ),
                                        foregroundColor:
                                            WidgetStateProperty.all(
                                              Colors.white,
                                            ),
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 12.0,
                                          ),
                                        ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                        ),
                                      ),

                                      child: const Icon(Icons.add, size: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "Judul",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          TextField(
                            controller: _judulController,
                            onChanged: (value) {
                              context.read<CreateCompetitionCubit>().setTitle(
                                value,
                              );
                            },
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.thirdBackGroundButton,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.thirdBackGroundButton,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.thirdBackGroundButton,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Deskripsi",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 50,
                            width: double.infinity,
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
                            child: TextField(
                              controller: _descriptionController,
                              onChanged: (value) => {
                                context
                                    .read<CreateCompetitionCubit>()
                                    .setDescription(value),
                              },
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Problem Statement",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 50,
                            width: double.infinity,
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
                            child: TextField(
                              controller: _problemStatementController,
                              onChanged: (value) => {
                                context
                                    .read<CreateCompetitionCubit>()
                                    .setProblemStatement(value),
                              },
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Jenis Pengumpulan",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 50,
                            width: double.infinity,
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
                            child: TextField(
                              controller: _jenisPengumpulanController,
                              onChanged: (value) => {
                                context
                                    .read<CreateCompetitionCubit>()
                                    .setSubmissionType(value),
                              },
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Jenis Kategori",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 5),
                          DropdownButton<CategoryEntity>(
                            value: dropdownValue,
                            items: categoryState.categories
                                .map(
                                  (category) =>
                                      DropdownMenuItem<CategoryEntity>(
                                        value: category,
                                        child: Text(category.category),
                                      ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                              context
                                  .read<CreateCompetitionCubit>()
                                  .setCategoryId(value!.categoryId);
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Petunjuk Teknis",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10),
                          Stack(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    BlocListener<
                                      SubmissionCubit,
                                      SubmissionState
                                    >(
                                      listener: (context, state) {
                                        if (state is SuccessUpload) {
                                          context
                                              .read<CreateCompetitionCubit>()
                                              .addGuidebookItemList(
                                                state.files,
                                              );
                                          _addNewfilesUrl(state.files);
                                        }
                                        if (state is SubmissionError) {
                                          context.showErrorToast(state.message);
                                        }
                                      },
                                      child: const SizedBox.shrink(),
                                    ),
                                    filesUrl.isEmpty
                                        ? BlocBuilder<
                                            SubmissionCubit,
                                            SubmissionState
                                          >(
                                            builder: (context, state) {
                                              if (state is SubmissionLoading) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 50,
                                                      ),
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.teal,
                                                      ),
                                                );
                                              }
                                              return Center(
                                                child: _buildUploadButton(
                                                  context,
                                                ),
                                              );
                                            },
                                          )
                                        : _buildFilesList(context),
                                  ],
                                ),
                              ),
                              // Tombol "Tambah"
                              if (filesUrl.isNotEmpty)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    child:
                                        BlocBuilder<
                                          SubmissionCubit,
                                          SubmissionState
                                        >(
                                          builder: (context, state) {
                                            final bool isLoading =
                                                state is SubmissionLoading;
                                            return InkWell(
                                              onTap: isLoading
                                                  ? null
                                                  : () {
                                                      context
                                                          .read<
                                                            SubmissionCubit
                                                          >()
                                                          .uploadFilesSubmissions();
                                                    },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.teal,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: isLoading
                                                      ? SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                color:
                                                                    Colors.teal,
                                                                strokeWidth: 2,
                                                              ),
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.add,
                                                              size: 20,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              "Tambah File",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    Colors.teal,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return SizedBox.shrink();
        },
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
      padding: EdgeInsets.fromLTRB(3, 0, 3, 80),
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

  Widget _buildImageContent(CreateCompImageState state) {
    if (state is CreateCompImageLoading) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } else if (state is CreateCompImageSuccess) {
      return Image.network(
        state.url,
        fit: BoxFit.cover,
        width: 150,
        height: 150,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('Gagal memuat.'));
        },
      );
    } else {
      return Container();
    }
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
}
