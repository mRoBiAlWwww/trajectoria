import 'package:flutter/material.dart';
import 'package:trajectoria/common/widgets/listItem/company_items.dart';
import 'package:trajectoria/common/widgets/listItem/jobseeker_items.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

class CompetitionListView extends StatelessWidget {
  final List<CompetitionEntity> competitions;
  final bool isBottomRounded;
  final bool isNotScrollable;
  final bool isJobseeker;

  const CompetitionListView({
    super.key,
    required this.competitions,
    this.isBottomRounded = false,
    this.isNotScrollable = false,
    this.isJobseeker = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFFBFBFB), Color(0xFFEDEDED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: (isBottomRounded == true)
            ? BorderRadius.circular(16)
            : BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
        border: Border.all(color: AppColors.thirdBackGroundButton, width: 2),
      ),
      // ListView utama
      child: ListView.separated(
        shrinkWrap: true,
        physics: isNotScrollable ? NeverScrollableScrollPhysics() : null,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.fromLTRB(145, 20, 25, 20),
          child: const Divider(
            color: AppColors.disableBackgroundButton,
            thickness: 1,
            height: 1,
          ),
        ),
        itemCount: competitions.length,
        itemBuilder: (context, index) {
          final competition = competitions[index];

          return isJobseeker
              ? JobseekerItems(competition: competition)
              : CompanyItems(competition: competition);
        },
      ),
    );
  }
}
