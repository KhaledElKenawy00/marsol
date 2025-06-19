import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/theme/theme_colors.dart';

class SavedLessonsPage extends StatelessWidget {
  const SavedLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الدروس المحفوظة"),
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
            Icon(Icons.bookmark, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              "لا يوجد دروس محفوظة",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/learning');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryRed,
              ),
              child: const Text("استكشف الدروس"),
            ),
          ],
        ),
      ),
    );
  }
}