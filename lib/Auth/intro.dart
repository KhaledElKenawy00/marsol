// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mersal_app/Auth/begin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late AnimationController _buttonController;
  late Animation<Offset> _imageAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _imageAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: Curves.easeOutCubic,
    ));

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutBack,
    ));

    _imageController.forward();
    _textController.forward();
    _buttonController.forward();
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }

  // Reusable GradientText widget
  Widget GradientText(
    String text, {
    required TextStyle style,
    required Animation<double> fadeAnimation,
    required Animation<Offset> slideAnimation,
  }) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color.fromARGB(255, 178, 34, 34),
              Color.fromARGB(255, 255, 145, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            text,
            style: style.copyWith(color: Colors.white), // Base color for shader
          ),
        ),
      ),
    );
  }

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        titleWidget: GradientText(
          "تواصل بسهولة!",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          fadeAnimation: _textFadeAnimation,
          slideAnimation: _textSlideAnimation,
        ),
        bodyWidget: FadeTransition(
          opacity: _textFadeAnimation,
          child: SlideTransition(
            position: _textSlideAnimation,
            child: Text(
              "تطبيقنا يساعدك على ترجمة لغة الإشارة إلى كلام باستخدام الذكاء الاصطناعي.",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        image: SlideTransition(
          position: _imageAnimation,
          child: Center(
            child: Image.asset(
              'assets/1.jpg',
              height: 350.0,
            ),
          ),
        ),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
      PageViewModel(
        titleWidget: GradientText(
          "كسر حواجز التواصل",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          fadeAnimation: _textFadeAnimation,
          slideAnimation: _textSlideAnimation,
        ),
        bodyWidget: FadeTransition(
          opacity: _textFadeAnimation,
          child: SlideTransition(
            position: _textSlideAnimation,
            child: Text(
              "نساعد الأفراد الصم على التواصل مع العالم بسهولة وسرعة.",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        image: SlideTransition(
          position: _imageAnimation,
          child: Center(
            child: Image.asset(
              'assets/2.jpg',
              height: 350.0,
            ),
          ),
        ),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
      PageViewModel(
        titleWidget: GradientText(
          "ربط العالم معًا",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          fadeAnimation: _textFadeAnimation,
          slideAnimation: _textSlideAnimation,
        ),
        bodyWidget: FadeTransition(
          opacity: _textFadeAnimation,
          child: SlideTransition(
            position: _textSlideAnimation,
            child: Text(
              "ترجم لغة الإشارة من أي مكان وفي أي وقت.",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        image: SlideTransition(
          position: _imageAnimation,
          child: Center(
            child: Image.asset(
              'assets/3.jpg',
              height: 350.0,
            ),
          ),
        ),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
      PageViewModel(
        titleWidget: GradientText(
          "استمع وتفاعل بسهولة",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          fadeAnimation: _textFadeAnimation,
          slideAnimation: _textSlideAnimation,
        ),
        bodyWidget: FadeTransition(
          opacity: _textFadeAnimation,
          child: SlideTransition(
            position: _textSlideAnimation,
            child: Text(
              "استخدم أزرار الترجمة والقراءة لتحويل الإشارات إلى كلام مسموع.",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        image: SlideTransition(
          position: _imageAnimation,
          child: Center(
            child: Image.asset(
              'assets/4.jpg',
              height: 350.0,
            ),
          ),
        ),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.only(top: 40),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with logo and "مرسال" text
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: SlideTransition(
                      position: _textSlideAnimation,
                      child: Image.asset(
                        "assets/logo2.jpg",
                        height: 120,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: SlideTransition(
                      position: _textSlideAnimation,
                      child: Text(
                        "مرسال",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // IntroductionScreen for the rest of the content
          Expanded(
            child: IntroductionScreen(
              pages: getPages(),
              onDone: () async {
                await _markOnboardingCompleted();
                Get.off(() => const Begin());
              },
              onChange: (index) {
                _imageController.reset();
                _textController.reset();
                _buttonController.reset();
                _imageController.forward();
                _textController.forward();
                _buttonController.forward();
              },
              showSkipButton: true,
              skip: ScaleTransition(
                scale: _buttonScaleAnimation,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 178, 34, 34),
                      Color.fromARGB(255, 255, 145, 0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    "تخطى",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              next: ScaleTransition(
                scale: _buttonScaleAnimation,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 178, 34, 34),
                      Color.fromARGB(255, 255, 145, 0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Icon(Icons.arrow_forward,
                      size: 30, color: Colors.white),
                ),
              ),
              done: ScaleTransition(
                scale: _buttonScaleAnimation,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 178, 34, 34),
                      Color.fromARGB(255, 255, 145, 0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    "ابدأ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              dotsDecorator: DotsDecorator(
                activeColor: const Color.fromARGB(255, 178, 34, 34),
                size: const Size(8, 8),
                activeSize: const Size(20, 10),
                activeShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                spacing: const EdgeInsets.symmetric(horizontal: 6),
                color: Colors.grey[400]!,
              ),
              globalBackgroundColor: Colors.white,
              bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
