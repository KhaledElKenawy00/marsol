import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/Homepage/profile_page.dart';
import 'package:mersal_app/Homepage/camera_page.dart';
import 'package:mersal_app/Homepage/text_to_sign_page.dart';
import 'package:mersal_app/Homepage/letters_page.dart';
import 'package:mersal_app/Homepage/learning_page.dart';
import 'package:mersal_app/Homepage/settings_page.dart';
import 'package:mersal_app/Homepage/saved_lessons_page.dart';
import 'package:mersal_app/Homepage/progress_page.dart';
import 'package:mersal_app/Homepage/help_page.dart';
import 'package:mersal_app/theme/theme_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

import 'firebase_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  List<int> _completedLetters = [];
  bool _isLoading = true;
  String _userName = '';
  String? _imageBase64;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCompletedLetters();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (mounted && data != null) {
        setState(() {
          _userName = data['name'] ?? '';
          _imageBase64 = prefs.getString('profile_image_${user.uid}');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadCompletedLetters() async {
    setState(() => _isLoading = true);
    try {
      _completedLetters = await FirebaseService.getCompletedLetters();
    } catch (e) {
      print('Error loading letters: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  void _navigateFromDrawer(int index) {
    Navigator.pop(context);
    switch (index) {
      case 0:
        setState(() => _currentIndex = 0);
        break;
      case 1:
        Get.to(() => const SavedLessonsPage());
        break;
      case 2:
        Get.to(() => const ProgressPage());
        break;
      case 3:
        Get.to(() => const SettingsPage());
        break;
      case 4:
        Get.to(() => const HelpPage());
        break;
      case 5:
        Share.share('حمل تطبيق مرسال لتعلم لغة الإشارة! رابط التحميل...');
        break;
      case 6:
        _signOut();
        break;
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/SignIn()');
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: ThemeColors.gradient),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileImage(),
                const SizedBox(height: 10),
                Text(_userName,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                const Text('مرحباً بك',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          _buildDrawerItem(
              Icons.home, 'الرئيسية', () => _navigateFromDrawer(0)),
          _buildDrawerItem(
              Icons.bookmark, 'الدروس المحفوظة', () => _navigateFromDrawer(1)),
          _buildDrawerItem(
              Icons.show_chart, 'سجل التقدم', () => _navigateFromDrawer(2)),
          _buildDrawerItem(
              Icons.settings, 'الإعدادات', () => _navigateFromDrawer(3)),
          _buildDrawerItem(
              Icons.help_outline, 'المساعدة', () => _navigateFromDrawer(4)),
          _buildDrawerItem(
              Icons.share, 'مشاركة التطبيق', () => _navigateFromDrawer(5)),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon, color: ThemeColors.primaryRed),
      title: Text(title),
      onTap: () => onTap(),
    );
  }

  Widget _buildProfileImage() {
    return _isLoading
        ? const CircularProgressIndicator(color: Colors.white)
        : CircleAvatar(
            radius: 30,
            backgroundColor: ThemeColors.button,
            backgroundImage: _imageBase64 != null
                ? MemoryImage(base64Decode(_imageBase64!))
                : null,
            child: _imageBase64 == null
                ? const Icon(Icons.person, size: 30)
                : null,
          );
  }

  Widget _getCurrentPage() {
    return [
      _buildHomeContent(),
      const TextToSignPage(),
      const LearningPage(),
      const ProfilePage(),
    ][_currentIndex];
  }

  Widget _buildHomeContent() {
    final progress = (_completedLetters.length - 1) / 28;
    final percentage = ((_completedLetters.length - 1) * 100 ~/ 28);

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding:
                  const EdgeInsets.all(16), // تم تقليل padding من 20 إلى 16
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16), // تم تقليل padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: ThemeColors.gradient),
                      borderRadius:
                          BorderRadius.circular(16), // تم تقليل نصف القطر
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          // أضيف FittedBox للنص الطويل
                          fit: BoxFit.scaleDown,
                          child: Text('مرحبا، $_userName!',
                              style: const TextStyle(
                                  fontSize:
                                      24, // تم تقليل حجم الخط من 30 إلى 24
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        const SizedBox(height: 8), // تم تقليل المسافة
                        const Text('واصل رحلتك في تعلم لغة الإشارة',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70)), // تم تقليل حجم الخط
                        const SizedBox(height: 16), // تم تقليل المسافة
                        _buildProgressCard(percentage, progress),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24), // تم تقليل المسافة من 30 إلى 24
                  _buildLearningSection(progress),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(int percentage, double progress) {
    return Container(
      padding: const EdgeInsets.all(12), // تم تقليل padding من 16 إلى 12
      decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(12)), // تم تقليل نصف القطر
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تقدمك',
                  style: TextStyle(
                      color: Colors.white, fontSize: 14)), // تم تقليل حجم الخط
              Text('$percentage%',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14)), // تم تقليل حجم الخط
            ],
          ),
          const SizedBox(height: 8), // تم تقليل المسافة
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            minHeight: 8, // تم تقليل الارتفاع من 10 إلى 8
            borderRadius: BorderRadius.circular(8), // تم تقليل نصف القطر
          ),
        ],
      ),
    );
  }

  Widget _buildLearningSection(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('واصل التعلم',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildLearningCard(
          'assets/A.jpg',
          'تعلم الحروف',
          'التعبير عن الحروف',
          progress,
          () => Get.to(() => const LettersPage()),
        ),
        // ✅ حذف الكارت الخاص بالأرقام
        // const SizedBox(height: 12),
        // _buildLearningCard(
        //   'assets/number1.jpg',
        //   'تعلم الأرقام',
        //   'التعبير عن الأرقام',
        //   0.0,
        //   () => Get.to(() => const NumbersPage()),
        // ),
      ],
    );
  }

  Widget _buildLearningCard(String image, String title, String subtitle,
      double progress, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12), // تم تقليل padding من 15 إلى 12
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // تم تقليل نصف القطر
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8, // تم تقليل blurRadius
              spreadRadius: 1, // تم تقليل spreadRadius
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50, // تم تقليل العرض من 60 إلى 50
              height: 50, // تم تقليل الارتفاع من 60 إلى 50
              decoration: BoxDecoration(
                color: ThemeColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8), // تم تقليل نصف القطر
              ),
              child: Image.asset(image, fit: BoxFit.contain), // أضيف fit
            ),
            const SizedBox(width: 12), // تم تقليل المسافة من 15 إلى 12
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold)), // تم تقليل حجم الخط
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12)), // تم تقليل حجم الخط
                  const SizedBox(height: 6), // تم تقليل المسافة
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(ThemeColors.primaryRed),
                    minHeight: 4, // تم تقليل الارتفاع
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon,
              size: 24, // تم تحديد حجم ثابت للأيقونات
              color: _currentIndex == index
                  ? ThemeColors.primaryRed
                  : Colors.grey),
          onPressed: () => _onTabTapped(index),
        ),
        Text(label,
            style: TextStyle(
                fontSize: 10, // تم تقليل حجم الخط
                color: _currentIndex == index
                    ? ThemeColors.primaryRed
                    : Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildNavigationDrawer(),
      appBar: AppBar(
        toolbarHeight: 70, // تعديل الارتفاع
        leadingWidth: 50, // إضافة عرض ثابت لمنطقة الـ leading
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, right: 5), // تعديل المسافات
          child: Image.asset(
            "assets/logo2.jpg",
            fit: BoxFit.contain,
          ),
        ),
        title: const Text('مرسال',
            style: TextStyle(
              fontSize: 22, // تعديل حجم الخط
              fontWeight: FontWeight.bold,
              height: 1.2, // تحسين إرتفاع السطر
            )),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              icon: const Icon(Icons.menu, size: 28),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ),
        ],
      ),
      body: SafeArea(child: _getCurrentPage()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CameraPage()),
        backgroundColor: ThemeColors.primaryRed,
        child: const Icon(Icons.camera_alt,
            size: 24, color: Colors.white), // تم تقليل حجم الأيقونة
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5, // تقليل الـ notchMargin
        padding: EdgeInsets.zero, // إزالة الـ padding الإضافي
        child: Container(
          height: 56, // ارتفاع قياسي للـ BottomNavigation
          padding: const EdgeInsets.symmetric(
              horizontal: 5), // تقليل المسافات الأفقية
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // توزيع متساوي
            children: [
              _buildNavButton(Icons.home, 'الرئيسية', 0),
              _buildNavButton(Icons.article, 'النصوص', 1),
              const SizedBox(width: 40), // مساحة للـ FAB
              _buildNavButton(Icons.school, 'التعلم', 2),
              _buildNavButton(
                  Icons.person, 'الملف الشخصي', 3), // تقليل طول النص
            ],
          ),
        ),
      ),
    );
  }
}
