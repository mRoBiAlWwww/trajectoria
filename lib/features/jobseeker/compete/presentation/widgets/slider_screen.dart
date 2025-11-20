import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/detail_competition_page.dart';

class SliderScreen extends StatefulWidget {
  final List<CompetitionEntity> competitions;
  const SliderScreen({super.key, required this.competitions});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final imageCompetitions = widget.competitions
        .where((comp) => comp.competitionImage.isNotEmpty)
        .toList();
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                AppNavigator.push(
                  context,
                  DetailCompetitionPage(
                    competition: widget.competitions[currentIndex],
                  ),
                );
              },
              child: CarouselSlider(
                items: imageCompetitions
                    .map(
                      (item) => Image.network(
                        item.competitionImage,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    )
                    .toList(),
                carouselController: carouselController,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  aspectRatio: 1.5,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageCompetitions.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => carouselController,
                    child: Container(
                      width: currentIndex == entry.key ? 17 : 7,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentIndex == entry.key
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
