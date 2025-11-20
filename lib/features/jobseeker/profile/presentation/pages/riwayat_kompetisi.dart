import 'package:flutter/material.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';

class RiwayatKompetisiPage extends StatelessWidget {
  const RiwayatKompetisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // Expanded(
                //   child: CompetitionListView(
                //     isBottomRounded: true,
                //     competitions: state.data,
                //     isNotScrollable: true,
                //     isJobseeker: false,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
