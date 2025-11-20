import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/finalis_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/finalis_state.dart';

class FinalisWidget extends StatelessWidget {
  final String competitionId;
  const FinalisWidget({super.key, required this.competitionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserFinalisCubit()..getFinalis(competitionId),
      child: BlocBuilder<UserFinalisCubit, UserFinalisState>(
        builder: (context, finalisState) {
          if (finalisState is UserFinalisLoaded) {
            if (finalisState.finalis.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Semua Peserta",
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: finalisState.finalis.length,
                      itemBuilder: (context, index) {
                        if (index >= finalisState.finalis.length) {
                          return SizedBox.shrink();
                        }
                        final submission = finalisState.finalis[index];
                        final DateTime submittedAtDate = submission.submittedAt
                            .toDate();
                        final DateTime deadlineDate = submission.submittedAt
                            .toDate();
                        final String formattedDate = DateFormat(
                          'd MMM y',
                          'id_ID',
                        ).format(deadlineDate);
                        final String countdown = timeAgo(submittedAtDate);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xFFFBFBFB),
                                Color(0xFFEDEDED),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.thirdBackGroundButton,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  finalisState.finalis[index].imageUrl,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Text('Gagal memuat.'),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(width: 10),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        finalisState.finalis[index].name,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "$countdown - $formattedDate",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.disableTextButton,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Skor",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    Text(
                                      finalisState.finalis[index].score
                                          .toInt()
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'JetBrainsMono',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<UserFinalisCubit>()
                                      .deleteFinalis(
                                        finalisState.finalis[index].finalisId,
                                      );
                                },
                                icon: Icon(
                                  CupertinoIcons.trash,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.not, width: 100, height: 100),
                  SizedBox(height: 10),
                  Text(
                    "Belum ada unggahan",
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryBackgroundButton,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Tunggu peserta mengirim jawaban di periode kompetisi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      color: AppColors.disableTextButton,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  String timeAgo(DateTime past) {
    final Duration difference = DateTime.now().difference(past);

    if (difference.inSeconds < 60) {
      return 'baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      final int hours = difference.inHours;
      final int minutes = difference.inMinutes % 60;
      return '$hours jam $minutes menit yang lalu';
    } else {
      final int days = difference.inDays;
      final int hours = difference.inHours % 24;
      return '$days hari $hours jam yang lalu';
    }
  }
}
