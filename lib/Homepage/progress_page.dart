import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/theme/theme_colors.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل التقدم"),
        backgroundColor: ThemeColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.primaryRed),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProgressCard(
              title: "الحروف المكتملة",
              progress: 0.65,
              count: 18,
              total: 28,
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required double progress,
    required int count,
    required int total,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.text,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: ThemeColors.primaryRed,
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text(
              "$count من $total",
              style: TextStyle(
                color: ThemeColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}