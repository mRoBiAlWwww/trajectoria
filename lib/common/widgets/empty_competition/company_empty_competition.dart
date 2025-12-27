import 'package:flutter/material.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/pages/create_competition.dart';

class CompanyEmptyCompetition extends StatelessWidget {
  const CompanyEmptyCompetition({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.not, width: 100, height: 100),
          const SizedBox(height: 10),
          Text(
            "Belum ada Kompetisi",
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w800,
              color: AppColors.secondaryBackgroundButton,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Mulailah membuat challenge untuk membuka peluang bagi peserta",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              color: AppColors.disableTextButton,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          IntrinsicWidth(
            child: InkWell(
              onTap: () {
                AppNavigator.push(context, CreateCompetitionPage());
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0XFFB2B2B2), Color(0xFF242424)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: const Text(
                    "+ Buat kompetisi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
