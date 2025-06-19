import 'package:flutter/material.dart';
import 'package:mersal_app/theme/theme_provider.dart';

class ThemeColors {
  static bool get isDarkMode => ThemeController.to.isDarkMode;

  // الألوان الأساسية للتطبيق
  static const Color primaryRed = Color.fromARGB(255, 178, 34, 34);
  static const Color primaryOrange = Color.fromARGB(255, 255, 145, 0);
  static const Color primaryAmber = Color(0xFFF4A261);

  // ألوان الخلفية
  static Color get background => isDarkMode ? darkBackground : whiteBackground;
  static Color get textinSTSG => isDarkMode ? whiteBackground : darkBackground;
  static Color get surface => isDarkMode ? darkSurface : lightBackground;
  static Color get cardBackground =>
      isDarkMode ? darkCardBackground : whiteBackground;
  static Color get cardIconBackground => lightCardIconBackground;
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color whiteBackground = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCardBackground = Color(0xFF1F2A44);
  static const Color lightCardIconBackground = Color(0xFFF9F3E8);
  static const Color darkCardIconBackground = Color(0xFF2D3748);

  // ألوان النصوص
  static Color get text => isDarkMode ? darkModeText : darkText;
  static Color get secondaryText => isDarkMode ? lightGreyText : greyText;
  static const Color darkText = Color(0xFF1F2A44);
  static const Color lightText = Color(0xFFF9FAFB);
  static const Color greyText = Color(0xFF6B7280);
  static const Color lightGreyText = Color(0xFFA3A8B3);
  static const Color darkModeText = Color(0xFFE5E7EB);

  // ألوان الأزرار والتفاعلات
  static Color get button => isDarkMode ? darkButton : buttonLightGrey;
  static const Color buttonGrey = Color(0xFF374151);
  static const Color buttonLightGrey = Color(0xFFE5E7EB);
  static const Color buttonAmber = Color(0xFFF4A261);
  static const Color buttonRed = Color(0xFFB22222);
  static const Color darkButton = Color(0xFF2D3748);

  // ألوان الظلال والتأثيرات
  static Color get shadow => isDarkMode ? darkShadowColor : shadowColor;
  static Color get amberShadow =>
      isDarkMode ? darkAmberShadow : lightAmberShadow;
  static const Color shadowColor = Color(0x1A1F2A44);
  static const Color darkShadowColor = Color(0x1A000000);
  static const Color lightAmberShadow = Color(0x33F4A261);
  static const Color darkAmberShadow = Color(0x33D97706);

  // ألوان التقدم والتحميل
  static Color get progressBg =>
      isDarkMode ? darkProgressBackground : progressBackground;
  static const Color progressBackground = Color(0x33E5E7EB);
  static const Color darkProgressBackground = Color(0x33A3A8B3);
  static const Color progressValue = Color(0xFFF4A261);
  static const Color progressGrey = Color(0xFFD1D5DB);

  // ألوان الحالة
  static const Color successColor = Color(0xFF2ECC71);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF4A261);
  static const Color infoColor = Color(0xFF3B82F6);

  // ألوان التدرج
  static List<Color> get gradient =>
      isDarkMode ? darkGradientColors : gradientColors;
  static const List<Color> gradientColors = [
    Color.fromARGB(255, 178, 34, 34),
    Color.fromARGB(255, 255, 145, 0),
  ];
  static const List<Color> darkGradientColors = [
    Color.fromARGB(255, 136, 14, 14),
    Color.fromARGB(255, 234, 88, 12),
  ];

  // ألوان القائمة السفلية
  static Color get bottomNavBg =>
      isDarkMode ? darkBottomNavBackground : whiteBackground;
  static const Color bottomNavSelected = Color(0xFFF4A261);
  static const Color bottomNavUnselected = Color(0xFF6B7280);
  static const Color darkBottomNavBackground = Color(0xFF161B22);
}
