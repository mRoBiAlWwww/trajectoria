import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';

class ProgressDetailPage extends StatelessWidget {
  final String imageUrl;
  const ProgressDetailPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  imageUrl == "" ? "https://via.placeholder.com/150" : imageUrl,
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
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Gagal memuat.'));
                  },
                ),
              ),
              SizedBox(height: 35),
              Text(
                "Aku telah mempelajari tentang pemrogramman selama 100 hari berturut-turut",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Streak aktif",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "100 hari",
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
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Total XP",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "3200",
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
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Liga",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Emas",
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
                  ],
                ),
              ),
              SizedBox(height: 30),
              BasicAppButton(
                onPressed: () {},
                backgroundColor: Colors.black,
                borderRad: 15,
                content: Text(
                  "Bagikan",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 10),
              BasicAppButton(
                onPressed: () {},
                backgroundColor: Colors.white,
                isBordered: true,
                borderColor: Colors.black,
                borderRad: 15,
                content: Text(
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
    );
  }
}
