import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/common/widgets/toast/toast.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';

class ProgressDetailPage extends StatefulWidget {
  final JobSeekerEntity jobseeker;
  const ProgressDetailPage({super.key, required this.jobseeker});

  @override
  State<ProgressDetailPage> createState() => _ProgressDetailPageState();
}

class _ProgressDetailPageState extends State<ProgressDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  String _getLeague(int score) {
    if (score >= 1000) return 'Platinum';
    if (score >= 500) return 'Emas';
    if (score >= 100) return 'Perak';
    return 'Perunggu';
  }

  void _onBagikan() {
    final score = widget.jobseeker.coursesScore;
    final name = widget.jobseeker.name;
    final league = _getLeague(score);
    final done = widget.jobseeker.competitionsDone.length;
    final text =
        'Cek progres belajarku di Trajectoria!\n'
        '👤 $name\n'
        '⭐ $score XP · 🏆 Liga $league · 🎯 $done kompetisi selesai\n'
        '#Trajectoria #BelajarBareng';

    Clipboard.setData(ClipboardData(text: text));
    context.showSuccessToast("Teks progres berhasil disalin ke clipboard");
  }

  void _onUnduh() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Fitur unduh kartu progres segera hadir!",
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.jobseeker.coursesScore;
    final league = _getLeague(score);
    final competitionsDone = widget.jobseeker.competitionsDone.length;

    return Scaffold(
      body: FadeTransition(
        opacity: CurvedAnimation(
          parent: _entranceController,
          curve: Curves.easeOut,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          )),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.jobseeker.profileImage.isEmpty
                          ? "https://via.placeholder.com/150"
                          : widget.jobseeker.profileImage,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
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
                        return const Center(child: Text('Gagal memuat.'));
                      },
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    "${widget.jobseeker.name} sudah menyelesaikan $competitionsDone kompetisi dan mengumpulkan $score XP di Trajectoria!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              AppVectors.fire,
                              width: 40.0,
                              height: 40.0,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Kompetisi selesai",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "$competitionsDone kompetisi",
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: AppColors.thirdBackGroundButton,
                            thickness: 1,
                            height: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              AppVectors.star,
                              width: 40.0,
                              height: 40.0,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Total XP",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "$score",
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: AppColors.thirdBackGroundButton,
                            thickness: 1,
                            height: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              AppVectors.gold,
                              width: 40.0,
                              height: 40.0,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Liga",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  league,
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  BasicAppButton(
                    onPressed: _onBagikan,
                    backgroundColor: Colors.black,
                    borderRad: 15,
                    verticalPadding: 15,
                    content: const Text(
                      "Bagikan",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BasicAppButton(
                    onPressed: _onUnduh,
                    backgroundColor: Colors.white,
                    isBordered: true,
                    borderColor: Colors.black,
                    borderRad: 15,
                    verticalPadding: 15,
                    content: const Text(
                      "Unduh",
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
          ),
        ),
      ),
    );
  }
}
