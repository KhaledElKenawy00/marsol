// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/Auth/createaccount.dart';
import 'package:mersal_app/Auth/signin.dart';

class Begin extends StatefulWidget {
  const Begin({super.key});

  @override
  _BeginState createState() => _BeginState();
}

class _BeginState extends State<Begin> with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _signInController;
  late AnimationController _signUpController;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<Offset> _signInSlideAnimation;
  late Animation<double> _signInScaleAnimation;
  late Animation<Offset> _signUpSlideAnimation;
  late Animation<double> _signUpScaleAnimation;

  @override
  void initState() {
    super.initState();

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
    _signInController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _signInSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _signInController,
      curve: Curves.easeOutCubic,
    ));
    _signInScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _signInController,
      curve: Curves.easeOutBack,
    ));
    _signUpController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _signUpSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _signUpController,
      curve: Curves.easeOutCubic,
    ));
    _signUpScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _signUpController,
      curve: Curves.easeOutBack,
    ));
    _textController.forward();
    _signInController.forward();
    _signUpController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _signInController.dispose();
    _signUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 178, 34, 34),
              Color.fromARGB(255, 255, 145, 0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _textFadeAnimation,
                child: SlideTransition(
                    position: _textSlideAnimation,
                    child: Image.asset(
                      "assets/logo2.jpg",
                      height: 200,
                      fit: BoxFit.fill,
                    )),
              ),
              FadeTransition(
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
                            color: Colors.orange.withOpacity(0.5),
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ]),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SlideTransition(
                position: _signInSlideAnimation,
                child: ScaleTransition(
                  scale: _signInScaleAnimation,
                  child: GestureDetector(
                    onTap: () => Get.off(SignIn()),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 15.75,
                      width: 400,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 5,
                            blurStyle: BlurStyle.normal,
                            offset: const Offset(0, 2.5),
                            spreadRadius: 2,
                          ),
                        ],
                        color: const Color.fromARGB(255, 178, 34, 34),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.transparent, width: 0),
                      ),
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 20.55,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _signUpSlideAnimation,
                child: ScaleTransition(
                  scale: _signUpScaleAnimation,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Get.off(signUp()),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 15.75,
                        width: 400,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                              blurStyle: BlurStyle.normal,
                              offset: const Offset(0, 2.5),
                              spreadRadius: 2,
                            ),
                          ],
                          color: const Color.fromARGB(255, 178, 34, 34),
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: Colors.transparent, width: 0),
                        ),
                        child: Text(
                          "انشاء حساب",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 20.55,
                          ),
                        ),
                      ),
                    ),
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
