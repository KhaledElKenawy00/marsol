import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/Homepage/letters_page.dart';
import 'package:mersal_app/theme/theme_colors.dart';

import 'homepage.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  Future<bool> _onWillPop() async {
    // ترجع true عشان تسمح بالرجوع فوراً بدون سؤال
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // يسمح بالرجوع على طول
      child: Scaffold(
        appBar: AppBar(
          title: const Text("مركز التعلم"),
          backgroundColor: ThemeColors.background,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ThemeColors.primaryRed),
              onPressed: () {
                Get.offUntil(
                  GetPageRoute(page: () => const Homepage()),
                      (route) => false,
                );
              } // ترجع على طول بدون سؤال
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              _buildLearningCard(
                title: "تعلم الحروف",
                icon: Icons.abc,
                color: Colors.blue,
                onTap: () => Get.to(() => const LettersPage()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearningCard({
    required String title,
    required IconData icon,
    required Color color,
    required Function() onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
