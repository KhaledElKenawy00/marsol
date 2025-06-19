import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mersal_app/Auth/intro.dart';
import 'package:mersal_app/Auth/signin.dart';
import 'package:mersal_app/Homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mersal_app/theme/theme_provider.dart';

import 'Homepage/help_page.dart';
import 'Homepage/learning_page.dart';
import 'Homepage/progress_page.dart';
import 'Homepage/saved_lessons_page.dart';
import 'Homepage/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkIfOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'مرسال - ترجمة لغة الإشارة',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      textDirection: TextDirection.rtl,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Get.find<ThemeController>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      getPages: <GetPage>[
        GetPage(name: '/learning', page: () => const LearningPage()),
        GetPage(name: '/settings', page: () => const SettingsPage()),
        GetPage(name: '/saved-lessons', page: () => const SavedLessonsPage()),
        GetPage(name: '/progress', page: () => const ProgressPage()),
        GetPage(name: '/help', page: () => const HelpPage()),
        GetPage(name: '/home', page: () => const Homepage()),
        GetPage(name: '/signin', page: () => const SignIn()),
      ],
      home: FutureBuilder<bool>(
        future: _checkIfOnboardingCompleted(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (FirebaseAuth.instance.currentUser != null) {
            return const Homepage();
          } else {
            return const IntroScreen();
          }
        },
      ),
    );
  }
}

class signup {
  const signup();
}

class createaccount {
  const createaccount();
}

class CreateAccount {
  const CreateAccount();
}

class signin {
  const signin();
}

class LoginPage {
  const LoginPage();
}
