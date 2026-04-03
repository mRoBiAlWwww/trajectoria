import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _contentController;
  late AnimationController _revealController;
  late Animation<double> _contentOpacity;
  late Animation<double> _revealAnimation;
  late Animation<Decoration> _insideButtonDecorationAnimation;
  late Animation<Decoration> _outerButtonDecorationAnimation;
  late Animation<double> _pulseAnimation;
  late VideoPlayerController _videoPlayerController;

  final GlobalKey _buttonKey = GlobalKey();
  Offset _revealCenter = Offset.zero;
  bool _showVideo = false;
  bool _showReveal = false;
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

    // Subtle breathing pulse for the button ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Entrance animation for non-Hero content (delayed to let Hero land)
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _contentOpacity = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) _contentController.forward();
    });

    // Circular reveal animation
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutQuart,
    );
    _revealController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _showVideo = true;
          _showReveal = false;
        });
      }
    });

    _initializePlayer();
  }

  void _startHold(BuildContext context) {
    _controller.forward();
    _pulseController.stop();
    _timer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        HapticFeedback.mediumImpact();
        _triggerReveal();
      }
    });
  }

  void _triggerReveal() {
    // Get button center position for the reveal origin
    final RenderBox? box =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      _revealCenter = Offset(
        position.dx + box.size.width / 2,
        position.dy + box.size.height / 2,
      );
    } else {
      _revealCenter = Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      );
    }
    setState(() {
      _showReveal = true;
    });
    _videoPlayerController.play();
    _revealController.forward();
  }

  void _cancelHold() {
    if (_showReveal) return;
    _timer?.cancel();
    _controller.reverse();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.asset(
      AppVideos.welcomeVideo,
    );

    _videoPlayerController.setLooping(false);
    _videoPlayerController.addListener(_onVideoEnd);
    await _videoPlayerController.initialize();
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
    _pulseController.dispose();
    _contentController.dispose();
    _revealController.dispose();
    _timer?.cancel();
    _videoPlayerController.removeListener(_onVideoEnd);
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showVideo
          ? _buildVideo()
          : Stack(
              fit: StackFit.expand,
              children: [
                // Normal UI
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 90,
                      horizontal: 25,
                    ),
                    child: Align(
                      alignment: AlignmentGeometry.center,
                      child: Column(
                        children: [
                          Hero(
                            tag: 'app_logo',
                            child: Transform.translate(
                              offset: const Offset(-5.0, 0.0),
                              child: Image.asset(
                                AppImages.logo,
                                width: 40,
                                height: 80,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Hero(
                            tag: 'app_title',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                "trajectoria",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'JetBrainsMono',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeTransition(
                            opacity: _contentOpacity,
                            child: _textUpper(context),
                          ),
                          Expanded(
                            child: FadeTransition(
                              opacity: _contentOpacity,
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
                                            child: ScaleTransition(
                                              scale: _pulseAnimation,
                                              child: ClipOval(
                                                child: Container(
                                                  key: _buttonKey,
                                                  width: 250,
                                                  height: 250,
                                                  padding: EdgeInsets.all(10),
                                                  decoration:
                                                      _outerButtonDecorationAnimation
                                                          .value,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                          fontWeight:
                                                              FontWeight.w400,
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
                          ),
                          const SizedBox(height: 70),
                          FadeTransition(
                            opacity: _contentOpacity,
                            child: Text(
                              "KETUK DAN TAHAN UNTUK MULAI",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'JetBrainsMono',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                // Circular reveal overlay — video spreads from button center
                if (_showReveal)
                  AnimatedBuilder(
                    animation: _revealController,
                    builder: (context, child) {
                      return ClipPath(
                        clipper: _CircularRevealClipper(
                          fraction: _revealAnimation.value,
                          center: _revealCenter,
                        ),
                        child: child,
                      );
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Gradient fallback while video loads first frames
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFB8C4FF), Color(0xFF7D98FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        // Video on top
                        _buildVideo(),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildVideo() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoPlayerController.value.size.width,
          height: _videoPlayerController.value.size.height,
          child: VideoPlayer(_videoPlayerController),
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

/// Clips a circular area that expands from [center] based on [fraction] (0→1).
class _CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  _CircularRevealClipper({required this.fraction, required this.center});

  @override
  Path getClip(Size size) {
    final dx = max(center.dx, size.width - center.dx);
    final dy = max(center.dy, size.height - center.dy);
    final maxRadius = sqrt(dx * dx + dy * dy);

    return Path()
      ..addOval(
        Rect.fromCircle(center: center, radius: maxRadius * fraction),
      );
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.center != center;
  }
}
