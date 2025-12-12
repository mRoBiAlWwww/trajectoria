import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/button_next_create_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competitions_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/create_detail.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/create_rubrik.dart';
import 'package:trajectoria/features/company/dashboard/presentation/widgets/create_schedule.dart';

class CreateCompetitionPage extends StatefulWidget {
  const CreateCompetitionPage({super.key});

  @override
  State<CreateCompetitionPage> createState() => _CreateCompetitionPageState();
}

class _CreateCompetitionPageState extends State<CreateCompetitionPage> {
  int page = 1;

  final customTextAppbar = ["Detail", "Rubrik", "Jadwal & hadiah"];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CreateCompetitionCubit()),
        BlocProvider(create: (context) => OrganizeCompetitionCubit()),
        BlocProvider(create: (context) => ButtonNextCreateCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.splashBackground,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Buat Kompetisi - ${customTextAppbar[page - 1]} ",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          titleSpacing: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: IndexedStack(
            index: page - 1,
            children: [
              SingleChildScrollView(child: CreateDetailWidget()),
              SingleChildScrollView(child: CreateRubrikWidget()),
              SingleChildScrollView(child: CreateScheduleWidget()),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: BlocBuilder<ButtonNextCreateCubit, bool>(
              builder: (context, state) {
                return BlocBuilder<
                  CreateCompetitionCubit,
                  CreateCompetitionState
                >(
                  builder: (context, finishState) {
                    //cek apakah semua data sudah diisi lengkap
                    final isComplete = context
                        .read<CreateCompetitionCubit>()
                        .isCompetitionComplete();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        page == 1
                            ? BasicAppButton(
                                onPressed: state
                                    ? () {
                                        context
                                            .read<ButtonNextCreateCubit>()
                                            .updateValid(false);
                                        setState(() {
                                          page++;
                                        });
                                      }
                                    : null,
                                backgroundColor:
                                    AppColors.secondaryBackgroundButton,
                                content: Text(
                                  "Lanjut",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : page == 3
                            ? Row(
                                children: [
                                  Expanded(
                                    child: BasicAppButton(
                                      onPressed: () {
                                        context
                                            .read<ButtonNextCreateCubit>()
                                            .updateValid(true);
                                        setState(() {
                                          page--;
                                        });
                                      },
                                      backgroundColor: Colors.white,
                                      isBordered: true,
                                      borderColor:
                                          AppColors.thirdBackGroundButton,
                                      content: Text(
                                        "Sebelumnya",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: BlocBuilder<AuthStateCubit, AuthState>(
                                      builder: (context, authState) {
                                        if (authState is AuthSuccess) {
                                          return BasicAppButton(
                                            onPressed: isComplete
                                                ? () {
                                                    context
                                                        .read<
                                                          CreateCompetitionCubit
                                                        >()
                                                        .setCompanyName(
                                                          authState
                                                              .company!
                                                              .name,
                                                        );
                                                    //cek apakah deadline lebih cepat dari pada tgl pembuatan
                                                    if (context
                                                        .read<
                                                          CreateCompetitionCubit
                                                        >()
                                                        .isDeadlineBeforeCreatedAt()) {
                                                      _displayErrorToast(
                                                        context,
                                                        "Tanggal deadline tidak boleh lebih awal dari tanggal pembuatan kompetisi",
                                                      );
                                                      return;
                                                    }

                                                    //ambil semua data dari cubit create competition
                                                    final competitionData = context
                                                        .read<
                                                          CreateCompetitionCubit
                                                        >()
                                                        .state
                                                        .competition;

                                                    //parsing data yg diambil ke cubit organize competition untuk disubmit
                                                    context
                                                        .read<
                                                          OrganizeCompetitionCubit
                                                        >()
                                                        .submitCompetition(
                                                          competitionData,
                                                        );
                                                    _displaySuccessToast(
                                                      context,
                                                      "Kompetisi berhasil dibuat",
                                                    );
                                                    Navigator.pop(context);
                                                  }
                                                : null,
                                            backgroundColor: AppColors
                                                .secondaryBackgroundButton,
                                            content: Text(
                                              "Terbitkan",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        }
                                        return SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: BasicAppButton(
                                      onPressed: () {
                                        context
                                            .read<ButtonNextCreateCubit>()
                                            .updateValid(true);
                                        setState(() {
                                          page--;
                                        });
                                      },
                                      backgroundColor: Colors.white,
                                      isBordered: true,
                                      borderColor:
                                          AppColors.thirdBackGroundButton,
                                      content: Text(
                                        "Sebelumnya",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: BasicAppButton(
                                      onPressed: state
                                          ? () {
                                              context
                                                  .read<ButtonNextCreateCubit>()
                                                  .updateValid(false);
                                              setState(() {
                                                page++;
                                              });
                                            }
                                          : null,
                                      backgroundColor:
                                          AppColors.secondaryBackgroundButton,
                                      content: Text(
                                        "Lanjut",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        TextButton(
                          onPressed: () {
                            final competitionData = context
                                .read<CreateCompetitionCubit>()
                                .state
                                .competition;
                            context
                                .read<OrganizeCompetitionCubit>()
                                .draftCompetition(competitionData);
                            _displaySuccessToast(
                              context,
                              "Rencana kompetisi berhasil disimpan sebagai draft",
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Simpan sebagai draft",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
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
