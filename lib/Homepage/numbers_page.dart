import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/theme/theme_colors.dart';

class NumbersPage extends StatelessWidget {
  const NumbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تعلم الأرقام',
          style: TextStyle(color: ThemeColors.text),
        ),
        backgroundColor: ThemeColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.primaryRed),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/number1.jpg', // نفس صورة البطاقة في الهوم بيج
              width: 150,
              height: 150,
            ),
            SizedBox(height: 30),
            Text(
              'تعلم الأرقام قريباً!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.primaryRed,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'نعمل حالياً على تطوير هذا القسم',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'شكراً لاهتمامك',
                  'سنخبرك عند إطلاق هذه الميزة',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: ThemeColors.primaryRed,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryRed,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                'حسناً',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}