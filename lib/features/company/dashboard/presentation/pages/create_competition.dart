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
  bool _canPop = false;
  final customTextAppbar = ["Detail", "Rubrik", "Jadwal & hadiah"];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CreateCompetitionCubit()),
        BlocProvider(create: (context) => OrganizeCompetitionCubit()),
        BlocProvider(create: (context) => ButtonNextCreateCubit()),
      ],
      child: PopScope(
        canPop: _canPop,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final bool? shouldSave = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Konfirmasi'),
              content: const Text('Simpan draft sebelum keluar?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Tidak'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Ya'),
                ),
              ],
            ),
          );

          if (context.mounted && shouldSave != null) {
            if (shouldSave == true) {
              final data = context
                  .read<CreateCompetitionCubit>()
                  .state
                  .competition;
              context.read<OrganizeCompetitionCubit>().draftCompetition(data);
              _displaySuccessToast(context, "Berhasil disimpan sebagai draft");
            }

            setState(() {
              _canPop = true;
            });

            await Future.delayed(Duration.zero);

            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
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
          bottomNavigationBar: _buildBottomBar(context),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: BlocBuilder<ButtonNextCreateCubit, bool>(
          builder: (context, isValid) {
            return BlocBuilder<CreateCompetitionCubit, CreateCompetitionState>(
              builder: (context, finsihState) {
                final isComplete = context
                    .read<CreateCompetitionCubit>()
                    .isCompetitionComplete();
                if (page == 1) {
                  return _buildNextButton(context, isValid);
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    page == 3
                        ? _buildFinishRow(context, isComplete)
                        : _buildNavigationRow(context, isValid),
                    _buildDraftButton(context),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // tombol "lanjut"
  Widget _buildNextButton(BuildContext context, bool isValid) {
    return BasicAppButton(
      onPressed: isValid
          ? () {
              context.read<ButtonNextCreateCubit>().updateValid(false);
              setState(() => page++);
            }
          : null,
      backgroundColor: AppColors.secondaryBackgroundButton,
      content: Text(
        "Lanjut",
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  // tombol "sebelumnya"
  Widget _buildPrevButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        context.read<ButtonNextCreateCubit>().updateValid(true);
        setState(() => page--);
      },
      backgroundColor: Colors.white,
      isBordered: true,
      borderColor: AppColors.thirdBackGroundButton,
      content: Text(
        "Sebelumnya",
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  // tombol "simpan sebagai draft"
  Widget _buildDraftButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        final data = context.read<CreateCompetitionCubit>().state.competition;

        context.read<OrganizeCompetitionCubit>().draftCompetition(data);

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
    );
  }

  //tombol "terbitkan"
  void _submitCompetition(BuildContext context, AuthSuccess authState) {
    final cubit = context.read<CreateCompetitionCubit>();

    cubit.setCompanyName(authState.company!.name);

    if (cubit.isDeadlineBeforeCreatedAt()) {
      _displayErrorToast(
        context,
        "Tanggal deadline tidak boleh lebih awal dari tanggal pembuatan kompetisi",
      );
      return;
    }

    final data = cubit.state.competition;
    context.read<OrganizeCompetitionCubit>().submitCompetition(data);

    _displaySuccessToast(context, "Kompetisi berhasil dibuat");
    Navigator.pop(context);
  }

  //untuk page 2
  Widget _buildNavigationRow(BuildContext context, bool isValid) {
    return Row(
      children: [
        Expanded(child: _buildPrevButton(context)),
        const SizedBox(width: 10),
        Expanded(child: _buildNextButton(context, isValid)),
      ],
    );
  }

  //untuk page 3
  Widget _buildFinishRow(BuildContext context, bool isComplete) {
    return Row(
      children: [
        Expanded(child: _buildPrevButton(context)),
        const SizedBox(width: 10),
        Expanded(
          child: BlocBuilder<AuthStateCubit, AuthState>(
            builder: (context, authState) {
              if (authState is AuthSuccess) {
                return BasicAppButton(
                  onPressed: isComplete
                      ? () => _submitCompetition(context, authState)
                      : null,
                  backgroundColor: AppColors.secondaryBackgroundButton,
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
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
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
