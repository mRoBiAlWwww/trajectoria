import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/listItem/competition_listitem.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/cubit/profile_cubit.dart';

class RiwayatKompetisiPage extends StatelessWidget {
  const RiwayatKompetisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getHistoryCompetitions(),
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
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, historyState) {
            if (historyState is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (historyState is HistoryCompetitionsLoaded) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: CompetitionListView(competitions: historyState.history),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
