import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/presentation/cubit/leaderboard_cubit.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

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
    return BlocProvider(
      create: (context) => JobseekerLeaderboardCubit()..getJobseekerByScore(),
      child: BlocBuilder<JobseekerLeaderboardCubit, JobseekerLeaderboardState>(
        builder: (context, state) {
          if (state is JobseekerLeaderboardLoading ||
              state is JobseekerLeaderboardInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is JobseekerLeaderboardFailure) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      "Gagal memuat data leaderboard",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context
                          .read<JobseekerLeaderboardCubit>()
                          .getJobseekerByScore(),
                      child: const Text("Coba lagi"),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is JobseekerLeaderboardLoaded) {
            return Scaffold(
              appBar: CustomAppBar(
                backgroundColor: AppColors.splashBackground,
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
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(1),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.thirdBackGroundButton,
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
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _entranceController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final itemSize = MediaQuery.of(context).size.height * 0.10;
                          final bigItemSize = MediaQuery.of(context).size.height * 0.14;
                          return SizedBox(
                        height: bigItemSize + 20,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: myRank.length,
                          itemBuilder: (context, index) {
                            double imageHeight = itemSize;
                            double imageWidth = itemSize;

                            if (index == 1) {
                              imageHeight = bigItemSize;
                              imageWidth = bigItemSize;
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
                      );
                        },
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
                                              width: 40,
                                              height: 40,
                                            )
                                          : index == 1
                                          ? Image.asset(
                                              AppImages.dua,
                                              width: 40,
                                              height: 40,
                                            )
                                          : index == 2
                                          ? Image.asset(
                                              AppImages.tiga,
                                              width: 40,
                                              height: 40,
                                            )
                                          : SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Center(
                                                child: Text(
                                                  (index + 1).toString(),
                                                  style: TextStyle(
                                                    fontFamily: "JetBrainsMono",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(width: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: Image.network(
                                          leaderbord.profileImage,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Container(
                                                  width: 40,
                                                  height: 40,
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
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          leaderbord.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 25),
                                Text(
                                  "${leaderbord.coursesScore.toString()} XP",
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontWeight: FontWeight.w700,
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
              ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
