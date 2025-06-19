import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/theme/theme_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mersal_app/Auth/authcontroller.dart';
import 'package:mersal_app/Homepage/settings_page.dart';

import 'homepage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = AuthController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Obx(() => WillPopScope(
          onWillPop: () async {
            // عند الضغط على زر الرجوع
            // نرجع للصفحة الرئيسية (غير اسم الصفحة حسب مسار تطبيقك)
            Get.offAllNamed('/home');
            // لمنع الرجوع التلقائي الافتراضي (إغلاق الصفحة)
            return false;
          },
          child: Scaffold(
            backgroundColor: ThemeColors.background,
            appBar: AppBar(
              backgroundColor: ThemeColors.background,
              title: Text(
                "حسابي",
                style: TextStyle(
                  color: ThemeColors.text,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: ThemeColors.text),
                  onPressed: () {
                    Get.offUntil(
                      GetPageRoute(page: () => const Homepage()),
                      (route) => false,
                    );
                  }),
            ),
            body: user == null
                ? const Center(child: Text("لا يوجد مستخدم مسجل الدخول"))
                : StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: ThemeColors.primaryAmber));
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("حدث خطأ أثناء تحميل البيانات"));
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(
                            child: Text("لا توجد بيانات للمستخدم"));
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final name = data['name'] ?? '';
                      final email = user.email ?? '';
                      final completedLetters =
                          (data['completedLetters'] as List?)?.length ?? 0;
                      final completedNumbers =
                          (data['completedNumbers'] as List?)?.length ?? 0;

                      return FutureBuilder<String?>(
                        future: _loadProfileImage(user.uid),
                        builder: (context, imageSnapshot) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child:
                                        _buildProfileImage(imageSnapshot.data)),
                                const SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: ThemeColors.text,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    email,
                                    style: TextStyle(
                                      color: ThemeColors.secondaryText,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                _buildSectionTitle("الإحصائيات"),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        "الحروف المكتملة",
                                        "${completedLetters - 1}/28",
                                        ThemeColors.primaryOrange,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                _buildSectionTitle("الإعدادات"),
                                const SizedBox(height: 16),
                                _buildSettingItem(
                                  Icons.settings_outlined,
                                  "الإعدادات",
                                  false,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SettingsPage()),
                                    );
                                  },
                                ),
                                _buildSettingItem(
                                  Icons.help_outline,
                                  "المساعدة والدعم",
                                  false,
                                ),
                                _buildSettingItem(
                                  Icons.logout,
                                  "تسجيل الخروج",
                                  false,
                                  onTap: () => _authController.signOut(),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ));
  }

  Future<String?> _loadProfileImage(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_$uid');
  }

  Widget _buildProfileImage(String? imageBase64) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: ThemeColors.button,
      backgroundImage:
          imageBase64 != null ? MemoryImage(base64Decode(imageBase64)) : null,
      child: imageBase64 == null
          ? Icon(
              Icons.person,
              size: 50,
              color: ThemeColors.secondaryText,
            )
          : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeColors.text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: ThemeColors.secondaryText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, bool hasSwitch,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: ThemeColors.secondaryText,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: ThemeColors.text,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            if (hasSwitch)
              Switch(
                value: true,
                onChanged: (value) {},
                activeColor: ThemeColors.primaryOrange,
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: ThemeColors.secondaryText,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

class HomePage {
  const HomePage();
}
