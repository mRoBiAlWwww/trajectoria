import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<String> titles = [
    "Kecocokan karier oleh AI",
    "Akses semua course tanpa batas",
    "Analisis performa kompetisi oleh AI",
  ];

  final List<String> subtitles = [
    "Temukan karier yang paling cocok dengan skill, gaya kerja, dan minatmu.",
    "Pelajari semua jalur karier, video pembelajaran khusus, kuasai materi mendalam, dan buka seluruh bab yang sebelumnya terkunci.",
    "Dapatkan ringkasan kekuatan & kelemahan dari setiap challenge yang kamu selesaikan.",
  ];

  final List<String> myImages = [
    AppImages.premium1,
    AppImages.premium2,
    AppImages.premium3,
  ];

  @override
  void initState() {
    super.initState();
    _autoPlay();
  }

  void _autoPlay() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 3));

      if (!mounted) return false;
      int nextPage = _controller.page!.round() + 1;
      _controller.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.splashBackground,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            "Trajectoria premium",
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white, Color(0xFFEDEDED)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Premium",
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      foreground: Paint()
                        ..shader =
                            const LinearGradient(
                              colors: [
                                Color(0xFF4B3480),
                                Color(0xFFC267FF),
                                Color(0xFFE5FF9E),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Nikmati insight AI penuh, analisis real-time, dan bimbingan karier.",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Tempat user Premium mengakses fitur AI cerdas untuk analisis, rekomendasi, dan personal mentor.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: AppColors.disableTextButton,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 225,
                        child: PageView.builder(
                          controller: _controller,
                          onPageChanged: (i) {
                            setState(() {
                              currentIndex = i % myImages.length;
                            });
                          },
                          itemBuilder: (context, index) {
                            final realIndex = index % myImages.length;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: Image.asset(
                                  myImages[realIndex],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              titles[currentIndex],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                subtitles[currentIndex],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.disableTextButton,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(myImages.length, (index) {
                          bool isActive = currentIndex == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 24 : 8,
                            height: 8,

                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.black
                                  : Colors.grey.shade400,

                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Tunggu apa lagi? Mulai sekarang.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF4B3480),
                          Color(0xFFC267FF),
                          Color(0xFFE5FF9E),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppVectors.upgrade,
                            width: 15.0,
                            height: 15.0,
                          ),
                          SizedBox(width: 4),
                          const Text(
                            "Upgrade Sekarang",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Lihat detail paket",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.secondaryText,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
