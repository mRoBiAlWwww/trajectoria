import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/presentation/cubit/leaderboard_cubit.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final List<String> myRank = [
    AppImages.ligaPerak,
    AppImages.ligaEmas,
    AppImages.ligaTerkunci,
    AppImages.ligaTerkunci,
    AppImages.ligaTerkunci,
    AppImages.ligaTerkunci,
    AppImages.ligaTerkunci,
    AppImages.ligaTerkunci,
  ];
  @override
  Widget build(BuildContext context) {
    debugPrint("Widget build: LeaderboardPage");
    return BlocProvider(
      create: (context) => JobseekerLeaderboardCubit()..getJobseekerByScore(),
      child: BlocBuilder<JobseekerLeaderboardCubit, JobseekerLeaderboardState>(
        builder: (context, state) {
          if (state is JobseekerLeaderboardLoaded) {
            return Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0.0,
                backgroundColor: AppColors.splashBackground,
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Liga Emas",
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.history_toggle_off),
                          SizedBox(width: 10),
                          Text(
                            "4 Hari",
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: myRank.length,
                          itemBuilder: (context, index) {
                            double imageHeight = 80;
                            double imageWidth = 80;

                            if (index == 1) {
                              imageHeight = 120;
                              imageWidth = 120;
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  myRank[index],
                                  height: imageHeight,
                                  width: imageWidth,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFFFBFBFB),
                              Color(0xFFEDEDED),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.thirdBackGroundButton,
                            width: 2,
                          ),
                        ),
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 20),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            final leaderbord = state.data[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      index == 0
                                          ? Image.asset(
                                              AppImages.satu,
                                              width: 50,
                                              height: 50,
                                            )
                                          : index == 1
                                          ? Image.asset(
                                              AppImages.dua,
                                              width: 50,
                                              height: 50,
                                            )
                                          : index == 2
                                          ? Image.asset(
                                              AppImages.tiga,
                                              width: 50,
                                              height: 50,
                                            )
                                          : SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Center(
                                                child: Text(
                                                  (index + 1).toString(),
                                                  style: TextStyle(
                                                    fontFamily: "JetBrainsMono",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(width: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: Image.network(
                                          leaderbord.profileImage,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          // loadingBuilder:
                                          //     (context, child, loadingProgress) {
                                          //       if (loadingProgress == null) {
                                          //         return child;
                                          //       }
                                          //       return Container(
                                          //         width: 40,
                                          //         height: 40,
                                          //         color: Colors.grey,
                                          //         child: const Center(
                                          //           child:
                                          //               CircularProgressIndicator(
                                          //                 color: Colors.white,
                                          //               ),
                                          //         ),
                                          //       );
                                          //     },
                                          // errorBuilder:
                                          //     (context, error, stackTrace) {
                                          //       return const Center(
                                          //         child: Text('Gagal memuat.'),
                                          //       );
                                          //     },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          leaderbord.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${leaderbord.coursesScore.toString()} XP",
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
