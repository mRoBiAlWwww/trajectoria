import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/core/config/assets/app_gifs.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:trajectoria/core/config/theme/app_colors.dart';

class GifSlideshow extends StatefulWidget {
  final gifPaths = [AppGifs.first, AppGifs.second, AppGifs.third];
  final linePaths = [
    AppVectors.lineonboard1,
    AppVectors.lineonboard2,
    AppVectors.lineonboard3,
  ];
  final List<String> subTitle = [
    "Trajectoria bantu kamu belajar lewat kompetisi dengan analisis AI",
    "Ikut kompetisi, uji skill, dan naik level bareng komunitas",
    "Raih sertifikat dan buka peluang karier baru",
  ];
  final paddings = [
    const EdgeInsets.all(20),
    EdgeInsets.zero,
    const EdgeInsets.all(40),
  ];
  final List<Duration> durasi = [
    const Duration(milliseconds: 3500),
    const Duration(milliseconds: 3500),
    const Duration(milliseconds: 4000),
  ];

  GifSlideshow({super.key});

  @override
  _GifSlideshowState createState() => _GifSlideshowState();
}

class _GifSlideshowState extends State<GifSlideshow> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    final currentDuration = widget.durasi[_currentIndex];
    _timer = Timer(currentDuration, () {
      final int nextIndex = (_currentIndex + 1) % widget.gifPaths.length;
      final String nextPath = widget.gifPaths[nextIndex];
      AssetImage(nextPath).evict(cache: PaintingBinding.instance.imageCache);
      setState(() {
        _currentIndex = nextIndex;
      });
      _startTimer();
    });
  }

  void _goToIndex(int index) {
    if (index == _currentIndex) return;
    _timer?.cancel();
    final String nextPath = widget.gifPaths[index];
    AssetImage(nextPath).evict(cache: PaintingBinding.instance.imageCache);
    setState(() {
      _currentIndex = index;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < -100) {
          // Swipe left → next
          _goToIndex((_currentIndex + 1) % widget.gifPaths.length);
        } else if (details.primaryVelocity! > 100) {
          // Swipe right → previous
          _goToIndex(
            (_currentIndex - 1 + widget.gifPaths.length) %
                widget.gifPaths.length,
          );
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, 30),
              child: Image.asset(
                AppImages.dot,
                color: Colors.white,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  widget.subTitle[_currentIndex],
                  key: ValueKey('text_$_currentIndex'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontFamily: 'Averia',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                key: ValueKey('gif_$_currentIndex'),
                width: 250,
                height: 250,
                padding: widget.paddings[_currentIndex],
                decoration: const BoxDecoration(
                  color: AppColors.secondaryBackgroundButton,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Center(
                    child: Image.asset(widget.gifPaths[_currentIndex]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: SvgPicture.asset(
                  key: ValueKey('line_$_currentIndex'),
                  widget.linePaths[_currentIndex],
                  width: 40.0,
                  height: 40.0,
                ),
              ),
              const SizedBox(height: 16),
              // Dot indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.gifPaths.length, (i) {
                  final isActive = i == _currentIndex;
                  return GestureDetector(
                    onTap: () => _goToIndex(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
