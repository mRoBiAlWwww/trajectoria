import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/finalis_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/finalis_state.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/get_user_compe_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/get_user_compe_state.dart';

class FinalisWidget extends StatelessWidget {
  final String competitionId;
  const FinalisWidget({super.key, required this.competitionId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserFinalisCubit()..getFinalis(competitionId),
        ),
        BlocProvider(create: (context) => GetUserCompeCubit()),
      ],
      child: BlocBuilder<UserFinalisCubit, UserFinalisState>(
        builder: (context, finalisState) {
          if (finalisState is UserFinalisLoaded) {
            if (finalisState.finalis.isNotEmpty) {
              final submissionIds = finalisState.finalis
                  .map((e) => e.submissionId)
                  .toList();
              context.read<GetUserCompeCubit>().loadAllUsers(submissionIds);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: BlocBuilder<GetUserCompeCubit, GetUserCompeState>(
                  builder: (context, userState) {
                    if (userState is UserCompeLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.teal),
                      );
                    }
                    if (userState is UserCompeAllUsersLoaded) {
                      return Column(
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

                              //formatter date
                              final formatter = DateFormat('d MMM y', 'id_ID');
                              final formattedDate = formatter.format(
                                submission.submittedAt.toDate(),
                              );
                              final String countdown = timeAgo(
                                submission.submittedAt.toDate(),
                              );

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        userState.users[index].profileImage,
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              );
                                            },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Center(
                                                child: Text('Gagal memuat.'),
                                              );
                                            },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userState.users[index].name,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "$countdown - $formattedDate",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    AppColors.disableTextButton,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 45,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              fontSize: 18,
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
                                              finalisState
                                                  .finalis[index]
                                                  .submissionId,
                                              competitionId,
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
                      );
                    }
                    return SizedBox.shrink();
                  },
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
                    "Belum ada finalis",
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryBackgroundButton,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Anda belum menambahkan partisipan kompetisi anda ke final sama sekali",
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
          if (finalisState is UserFinalisLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
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
