import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/common/widgets/list_competition/list_competition_items.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/cubit/profile_cubit.dart';

class RiwayatKompetisiPage extends StatefulWidget {
  const RiwayatKompetisiPage({super.key});

  @override
  State<RiwayatKompetisiPage> createState() => _RiwayatKompetisiPageState();
}

class _RiwayatKompetisiPageState extends State<RiwayatKompetisiPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getHistoryCompetitions(),
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: AppColors.splashBackground,
          showLeading: true,
          title: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Column(
                children: [
                  Text(
                    "Riwayat Kompetisi",
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: FadeTransition(
          opacity: CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOut,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _entranceController,
              curve: Curves.easeOutCubic,
            )),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, historyState) {
                if (historyState is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (historyState is ProfileFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Gagal memuat riwayat kompetisi",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => context
                              .read<ProfileCubit>()
                              .getHistoryCompetitions(),
                          child: const Text("Coba lagi"),
                        ),
                      ],
                    ),
                  );
                }
                if (historyState is HistoryCompetitionsLoaded) {
                  if (historyState.history.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada riwayat kompetisi",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CompetitionListView(
                      competitions: historyState.history,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
