import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/detail_competition_page.dart';

class JobseekerItems extends StatelessWidget {
  final CompetitionEntity competition;

  const JobseekerItems({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    final DateTime deadlineDate = competition.deadline.toDate();
    final String formattedDate = DateFormat(
      'd MMM y',
      'id_ID',
    ).format(deadlineDate);

    return InkWell(
      onTap: () {
        AppNavigator.push(
          context,
          BlocProvider.value(
            value: context.read<SearchCompeteCubit>(),
            child: DetailCompetitionPage(competition: competition),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GAMBAR
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
                    competition.companyName,
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),

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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.emoji_events, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          competition.rewardDescription,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
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
