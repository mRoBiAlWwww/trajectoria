import 'package:flutter/material.dart';
import 'package:trajectoria/core/config/assets/app_gifs.dart';

class ScoreGift extends StatelessWidget {
  const ScoreGift({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppGifs.loadingScore, width: 75, height: 75),
          Text(
            "Menghitung Skor...",
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
