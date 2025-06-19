// ignore_for_file: avoid_print, body_might_complete_normally_nullable, deprecated_member_use, library_private_types_in_public_api, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/Auth/authcontroller.dart';
import 'package:mersal_app/Auth/begin.dart';
import 'package:mersal_app/widgets/Mytextform.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<signUp> with TickerProviderStateMixin {
  final AuthController _authController = AuthController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController conpasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  AnimationController? _containerController;
  AnimationController? _textController;
  AnimationController? _buttonController;
  Animation<Offset>? _containerSlideAnimation;
  Animation<double>? _textFadeAnimation;
  Animation<Offset>? _textSlideAnimation;
  Animation<double>? _buttonScaleAnimation;
  double _tapScale = 1.0;

  @override
  void initState() {
    super.initState();

    _containerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _containerSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _containerController!,
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
      parent: _textController!,
      curve: Curves.easeIn,
    ));
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _textController!,
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
      parent: _buttonController!,
      curve: Curves.easeOutBack,
    ));

    _containerController!.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && _textController != null) {
        _textController!.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted && _buttonController != null) {
        _buttonController!.forward();
      }
    });
  }

  @override
  void dispose() {
    _containerController?.dispose();
    _textController?.dispose();
    _buttonController?.dispose();
    emailController.dispose();
    nameController.dispose();
    conpasswordController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
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
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 20.55,
                            MediaQuery.of(context).size.width / 20.55,
                            MediaQuery.of(context).size.width / 20.55,
                            0),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => Get.off(Begin()),
                                icon: Icon(Icons.keyboard_backspace_sharp,
                                    size: 30,
                                    color: Colors.black,
                                    shadows: [
                                      Shadow(
                                        color: Colors.orange.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ])),
                            SizedBox(width: 10),
                            Text(
                              "انشاء حساب",
                              style: TextStyle(
                                color: Colors.black,
                                shadows: [
                                  Shadow(
                                    color: Colors.orange.withOpacity(0.5),
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                                fontSize: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: FadeTransition(
                          opacity: _textFadeAnimation!,
                          child: SlideTransition(
                            position: _textSlideAnimation!,
                            child: Image.asset(
                              "assets/logo2.jpg",
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: FadeTransition(
                          opacity: _textFadeAnimation!,
                          child: SlideTransition(
                            position: _textSlideAnimation!,
                            child: Text(
                              "مرسال",
                              style: TextStyle(
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                      color: Colors.orange.withOpacity(0.5),
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                  fontSize: 50,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 20.55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SlideTransition(
                              position: _containerSlideAnimation!,
                              child: Container(
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 5,
                                        blurStyle: BlurStyle.normal,
                                        offset: Offset(0, 2.5),
                                        spreadRadius: 2)
                                  ],
                                  color: const Color.fromARGB(255, 178, 34, 34),
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                child: Form(
                                  key: formkey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FadeTransition(
                                        opacity: _textFadeAnimation!,
                                        child: SlideTransition(
                                          position: _textSlideAnimation!,
                                          child: Text(
                                            "الاسم",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    20,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.orange
                                                        .withOpacity(0.5),
                                                    blurRadius: 2,
                                                    offset: Offset(1, 1),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              205.5),
                                      FadeTransition(
                                        opacity: _textFadeAnimation!,
                                        child: SlideTransition(
                                          position: _textSlideAnimation!,
                                          child: TextForm(
                                            hint: 'الاسم',
                                            controller: nameController,
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "الرجاء إدخال اسمك";
                                              } else if (val.length < 5) {
                                                return "يجب أن يتكون الاسم من 5 أحرف على الأقل";
                                              } else if (!RegExp(
                                                      r'^[a-zA-Z\s]+$')
                                                  .hasMatch(val)) {
                                                return "يجب أن يحتوي الاسم على أحرف ومسافات فقط";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              100),
                                      FadeTransition(
                                        opacity: _textFadeAnimation!,
                                        child: SlideTransition(
                                          position: _textSlideAnimation!,
                                          child: Text(
                                            "بريد إلكتروني",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              205.5),
                                      FadeTransition(
                                        opacity: _textFadeAnimation!,
                                        child: SlideTransition(
                                          position: _textSlideAnimation!,
                                          child: TextForm(
                                            hint: 'بريد إلكتروني',
                                            controller: emailController,
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "الرجاء إدخال البريد الإلكتروني الخاص بك";
                                              } else if (!val.trim().isEmail) {
                                                return "الرجاء إدخال بريد إلكتروني صالح";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              100),
                                      FadeTransition(
                                        opacity: _textFadeAnimation!,
                                        child: SlideTransition(
                                          position: _textSlideAnimation!,
                                          child: Text(
                                            "كلمة السر",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              205.5),
                                      FadeTransition(
                                        opacity: _textFadeAnimation!,
                                        child: SlideTransition(
                                          position: _textSlideAnimation!,
                                          child: PTextForm(
                                            hint: "كلمة السر",
                                            controller: passwordController,
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "الرجاء إدخال كلمة المرور الخاصة بك";
                                              } else if (val.length < 6) {
                                                return "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل";
                                              } else if (!RegExp(
                                                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                                                  .hasMatch(val)) {
                                                return "يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل, one lowercase letter, and one number";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              100),
                                      FadeTransition(
                                        opacity: _textFadeAnimation!,
                                        child: SlideTransition(
                                          position: _textSlideAnimation!,
                                          child: Text(
                                            "تأكيد كلمة السر",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              205.5),
                                      FadeTransition(
                                        opacity: _textFadeAnimation!,
                                        child: SlideTransition(
                                          position: _textSlideAnimation!,
                                          child: PTextForm(
                                            hint: "تأكيد كلمة السر",
                                            controller: conpasswordController,
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "يرجى تأكيد كلمة المرور الخاصة بك";
                                              } else if (val !=
                                                  passwordController.text) {
                                                return "كلمات المرور غير متطابقة";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Center(
                                        child: Obx(() => _authController
                                                .isLoading.value
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    15.75,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.11,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 178, 34, 34),
                                                      Colors.white,
                                                      Color.fromARGB(
                                                          255, 178, 34, 34),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color.fromARGB(255,
                                                              255, 145, 0)),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTapDown: (_) {
                                                  setState(() {
                                                    _tapScale = 0.95;
                                                  });
                                                },
                                                onTapUp: (_) {
                                                  setState(() {
                                                    _tapScale = 1.0;
                                                  });
                                                },
                                                onTapCancel: () {
                                                  setState(() {
                                                    _tapScale = 1.0;
                                                  });
                                                },
                                                onTap: () {
                                                  print(MediaQuery.of(context)
                                                      .size
                                                      .height);
                                                  print(MediaQuery.of(context)
                                                      .size
                                                      .width);
                                                  if (formkey.currentState!
                                                      .validate()) {
                                                    _authController.signup(
                                                        nameController.text
                                                            .trim(),
                                                        emailController.text
                                                            .trim(),
                                                        passwordController.text
                                                            .trim());
                                                    Get.snackbar("مرسال",
                                                        "تم إنشاء الحساب",
                                                        duration: Duration(
                                                            seconds: 1));
                                                  }
                                                },
                                                child: AnimatedScale(
                                                  scale: _tapScale,
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  child: FadeTransition(
                                                    opacity:
                                                        _textFadeAnimation!,
                                                    child: ScaleTransition(
                                                      scale:
                                                          _buttonScaleAnimation!,
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            15.75,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.11,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  178,
                                                                  34,
                                                                  34),
                                                              Colors.white,
                                                              Color.fromARGB(
                                                                  255,
                                                                  178,
                                                                  34,
                                                                  34),
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.2),
                                                              blurRadius: 8,
                                                              offset:
                                                                  Offset(0, 4),
                                                            ),
                                                          ],
                                                          border: Border.all(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "انشاء حساب",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                20.55,
                                                            shadows: [
                                                              Shadow(
                                                                color: Colors
                                                                    .orange
                                                                    .withOpacity(
                                                                        0.5),
                                                                blurRadius: 2,
                                                                offset: Offset(
                                                                    1, 1),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
