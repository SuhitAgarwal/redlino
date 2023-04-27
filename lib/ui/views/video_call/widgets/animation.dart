import 'package:flutter/material.dart';

import '../../../shared/profile_pic.dart';

class LuckyFanAnim extends StatefulWidget {
  final String winnerName;
  final String? winnerPhotoURL;
  final String? celebPhotoURL;
  final List<String?> photoURLs;
  final VoidCallback onFinished;

  const LuckyFanAnim({
    Key? key,
    required this.winnerName,
    required this.winnerPhotoURL,
    required this.celebPhotoURL,
    required this.photoURLs,
    required this.onFinished,
  }) : super(key: key);

  @override
  _LuckyFanAnimState createState() => _LuckyFanAnimState();
}

class _LuckyFanAnimState extends State<LuckyFanAnim>
    with TickerProviderStateMixin {
  late String? imageUrl;
  late AnimationController imgScaleController;
  double labelTextOpacity = 0;
  double winnerOpacity = 0;

  @override
  void initState() {
    imgScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    startAnimation();
    super.initState();
  }

  void startAnimation() async {
    for (var i = 0; i < 16; i++) {
      for (final img in widget.photoURLs) {
        imageUrl = img;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }
    imgScaleController.reverse();
    setState(() {
      labelTextOpacity = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      winnerOpacity = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    widget.onFinished();
  }

  @override
  void dispose() {
    imgScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ColoredBox(
        color: Colors.black87,
        child: Stack(
          children: [
            const Positioned(
              top: 96,
              left: 20,
              right: 20,
              child: Text(
                "It's time to select OUR Lucky Fan!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              bottom: 96,
              left: 20,
              child: ScaleTransition(
                scale: imgScaleController,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          gaplessPlayback: true,
                          width: 128,
                          height: 128,
                        )
                      : Image.asset(
                          'assets/profile-default.jpg',
                          gaplessPlayback: true,
                          width: 128,
                          height: 128,
                        ),
                ),
              ),
            ),
            Positioned(
              bottom: 96,
              right: 20,
              child: ScaleTransition(
                scale: imgScaleController,
                child: ProfilePic(url: widget.celebPhotoURL, size: 64),
              ),
            ),
            Positioned.fill(
              bottom: 172,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  child: const Text(
                    'Our lucky winner is...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  opacity: labelTextOpacity,
                  duration: const Duration(milliseconds: 800),
                ),
              ),
            ),
            Positioned.fill(
              top: 60,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: widget.winnerPhotoURL != null
                        ? Image.network(
                            widget.winnerPhotoURL!,
                            width: 128,
                            height: 128,
                          )
                        : Image.asset(
                            'assets/profile-default.jpg',
                            width: 128,
                            height: 128,
                          ),
                  ),
                  opacity: winnerOpacity,
                  duration: const Duration(milliseconds: 800),
                ),
              ),
            ),
            Positioned.fill(
              top: 260,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  child: Text(
                    widget.winnerName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  opacity: winnerOpacity,
                  duration: const Duration(milliseconds: 800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
