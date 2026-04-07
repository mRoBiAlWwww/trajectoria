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

class _PremiumPageState extends State<PremiumPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
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
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _entranceController.forward();
    });
    _autoPlay();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _showUpgradeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.splashBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Trajectoria Premium",
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Akses penuh ke semua fitur AI, course tanpa batas, dan analisis kompetisi.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _packageTile("Bulanan", "Rp 49.000 / bulan", "Akses penuh 30 hari"),
            const SizedBox(height: 12),
            _packageTile("Tahunan", "Rp 399.000 / tahun", "Hemat 32% · Akses 365 hari"),
            const SizedBox(height: 24),
            const Text(
              "Fitur pembayaran sedang dalam pengembangan.\nHubungi tim kami untuk info lebih lanjut.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Tutup",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageTile(String title, String price, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.thirdBackGroundButton, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
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
      body: FadeTransition(
        opacity: CurvedAnimation(
          parent: _entranceController,
          curve: Curves.easeOut,
        ),
        child: SingleChildScrollView(
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
                        height: MediaQuery.of(context).size.height * 0.26,
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
                        height: MediaQuery.of(context).size.height * 0.18,
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
                      onPressed: () => _showUpgradeSheet(context),
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
                    onTap: () => _showUpgradeSheet(context),
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
      ),
    );
  }
}
