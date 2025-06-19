import 'package:flutter/material.dart';
import 'package:mersal_app/theme/theme_colors.dart';
import 'package:mersal_app/theme/theme_provider.dart';
import 'package:get/get.dart';
import 'package:mersal_app/Homepage/edit_profile_page.dart';
import 'package:mersal_app/Homepage/change_password_page.dart';
import 'package:mersal_app/Auth/authcontroller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: ThemeColors.background,
          appBar: AppBar(
            backgroundColor: ThemeColors.background,
            title: Text(
              "الإعدادات",
              style: TextStyle(
                color: ThemeColors.text,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ThemeColors.text),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("الحساب"),
                _buildSettingItem(
                  Icons.person_outline,
                  "تعديل الملف الشخصي",
                  false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()),
                    );
                  },
                ),
                _buildSettingItem(
                  Icons.lock_outline,
                  "تغيير كلمة المرور",
                  false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage()),
                    );
                  },
                ),
                const SizedBox(height: 32),
                _buildSectionTitle("المظهر"),
                _buildSettingItem(
                  Icons.brightness_6,
                  "الوضع الليلي",
                  true,
                  value: ThemeController.to.isDarkMode,
                  onChanged: (value) {
                    ThemeController.to.toggleTheme();
                  },
                ),
                const SizedBox(height: 32),
                _buildSectionTitle("المساعدة والدعم"),
                _buildSettingItem(
                  Icons.help_outline,
                  "المساعدة",
                  false,
                  onTap: () {
                    // Add help functionality here
                  },
                ),
                _buildSettingItem(
                  Icons.info_outline,
                  "عن التطبيق",
                  false,
                  onTap: () {
                    // Add about functionality here
                  },
                ),
                const SizedBox(height: 32),
                _buildSettingItem(
                  Icons.logout,
                  "تسجيل الخروج",
                  false,
                  onTap: () => AuthController().signOut(),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: ThemeColors.text,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    bool hasSwitch, {
    bool? value,
    ValueChanged<bool>? onChanged,
    VoidCallback? onTap,
  }) {
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
                value: value ?? false,
                onChanged: onChanged,
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
