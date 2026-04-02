import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/widgets/animation/staggered_column.dart';
import 'package:trajectoria/common/widgets/appbar/custom_appbar.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_vectors.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:trajectoria/core/navigation/main_wrapper.dart';

class GetStartePage extends StatefulWidget {
  const GetStartePage({super.key});

  @override
  State<GetStartePage> createState() => _GetStartePageState();
}

class _GetStartePageState extends State<GetStartePage>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 30.0,
              icon: SvgPicture.asset(
                AppVectors.close,
                width: 40.0,
                height: 40.0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 60),
        child: Align(
          alignment: AlignmentGeometry.center,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          AppImages.dot,
                          color: const Color.fromARGB(255, 86, 86, 86),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: RotationTransition(
                          turns: _rotationController,
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border: const GradientBoxBorder(
                                gradient: SweepGradient(
                                  colors: [
                                    Color(0xFFE5FF9E),
                                    Color(0xFFC267FF),
                                    Color(0xFF4B3480),
                                    Color(0xFFE5FF9E),
                                  ],
                                ),
                                width: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: ClipOval(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: SvgPicture.asset(
                                AppVectors.arrow,
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: StaggeredColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Mulai perjalananmu dari sekarang juga",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: "Averia",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Kompetisi, Pembelajaran, Peluang, Semua dalam satu tempat.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30),
                    _continueButton(context),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        AppNavigator.pushAndRemove(
          context,
          MainWrapper(),
          // BlocProvider.value(
          //   value: context.read<AuthStateCubit>(),
          //   child: MainWrapper(),
          // ),
        );
      },
      backgroundColor: Colors.black,
      content: Text(
        "Lanjut",
        style: const TextStyle(
          fontSize: 18,
          fontFamily: "Inter",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
