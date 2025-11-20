import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/core/config/assets/app_videos.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signin_or_signup_page.dart';
import 'package:video_player/video_player.dart';

class WelcomeAnimationPage extends StatefulWidget {
  const WelcomeAnimationPage({super.key});

  @override
  State<WelcomeAnimationPage> createState() => _WelcomeAnimationPageState();
}

class _WelcomeAnimationPageState extends State<WelcomeAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Decoration> _insideButtonDecorationAnimation;
  late Animation<Decoration> _outerButtonDecorationAnimation;
  late VideoPlayerController _videoPlayerController;
  bool _showVideo = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _insideButtonDecorationAnimation = DecorationTween(
      begin: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFE8F0FF), Color(0xFF7D98FF)],
        ),
      ),
      end: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        ),
      ),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _outerButtonDecorationAnimation = DecorationTween(
      begin: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Colors.white, Colors.white]),
      ),
      end: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFE8F0FF), Color(0xFF7D98FF)],
        ),
      ),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _initializePlayer();
  }

  void _startHold(BuildContext context) {
    _controller.forward();
    _timer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showVideo = true;
        });
        _videoPlayerController.play();
      }
    });
  }

  void _cancelHold() {
    _timer?.cancel();
    _controller.reverse();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.asset(
      AppVideos.welcomeVideo,
    );

    _videoPlayerController.setLooping(false);

    _videoPlayerController.addListener(_onVideoEnd);

    await _videoPlayerController.initialize();

    // if (mounted) {
    //   setState(() {});
    // }
  }

  void _onVideoEnd() {
    if (!_videoPlayerController.value.isPlaying &&
        _videoPlayerController.value.position ==
            _videoPlayerController.value.duration) {
      _videoPlayerController.removeListener(_onVideoEnd);

      if (mounted) {
        AppNavigator.pushAndRemove(context, SigninOrSignupPage());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _videoPlayerController.removeListener(_onVideoEnd);
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _showVideo
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoPlayerController.value.size.width,
                    height: _videoPlayerController.value.size.height,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 90,
                  horizontal: 25,
                ),
                child: Align(
                  alignment: AlignmentGeometry.center,
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(-5.0, 0.0),
                        child: Image.asset(
                          AppImages.logo,
                          width: 40,
                          height: 80,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "trajectoria",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _textUpper(context),
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (_) => _startHold(context),
                          onTapUp: (_) => _cancelHold(),
                          onTapCancel: _cancelHold,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return SizedBox(
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        AppImages.dot,
                                        color: Colors.black,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Center(
                                      child: Center(
                                        child: ClipOval(
                                          child: Container(
                                            width: 250,
                                            height: 250,
                                            padding: EdgeInsets.all(10),
                                            decoration:
                                                _outerButtonDecorationAnimation
                                                    .value,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 75.0,
                                                  height: 75.0,
                                                  decoration:
                                                      _insideButtonDecorationAnimation
                                                          .value,
                                                  child: Icon(
                                                    Icons.bolt,
                                                    size: 30,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Mulai Sekarang",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'Averia',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      Text(
                        "KETUK DAN TAHAN UNTUK MULAI",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _textUpper(BuildContext context) {
    return Column(
      children: [
        Text(
          "Temukan arah,",
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "wujudkan mimpi.",
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
