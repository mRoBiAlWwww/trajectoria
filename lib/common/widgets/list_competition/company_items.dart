import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:trajectoria/common/helper/date/date_convert.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/pages/detail_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

class CompanyItems extends StatelessWidget {
  final CompetitionEntity competition;

  const CompanyItems({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    //formatter date
    final formattedDate = competition.deadline.toShortDate();

    return InkWell(
      onTap: () {
        AppNavigator.push(
          context,
          DetailCompetitionPage(
            competitionId: competition.competitionId,
            competitionName: competition.title,
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: competition.competitionImage.isNotEmpty
                ? Image.network(
                    competition.competitionImage,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 110,
                    height: 110,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image_not_supported),
                  ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    competition.status,
                    style: TextStyle(
                      color: competition.status == "Dirilis"
                          ? AppColors.secondPositiveColor
                          : competition.status == "Disimpan"
                          ? Colors.amber
                          : AppColors.doveRedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    competition.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 10),
                  const DottedLine(
                    dashLength: 6,
                    dashGapLength: 3,
                    lineThickness: 1,
                    dashColor: AppColors.disableBackgroundButton,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.flag, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
