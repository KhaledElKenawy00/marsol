import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mersal_app/theme/theme_colors.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مركز المساعدة"),
        backgroundColor: ThemeColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.primaryRed),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpItem(
            question: "كيف أبدأ في تعلم الحروف؟",
            answer: "اضغط على قسم 'التعلم' ثم اختر 'تعلم الحروف'",
          ),
          const Divider(),
          _buildHelpItem(
            question: "كيف أحفظ الدروس؟",
            answer: "اضغط على أيقونة الإشارة النجمية أثناء التعلم لحفظ الدرس",
          ),
          const Divider(),
          _buildHelpItem(
            question: "كيف أتابع تقدمي؟",
            answer: "يمكنك مراجعة تقدمك في قسم 'سجل التقدم'",
          ),
          const Divider(),
          _buildHelpItem(
            question: "كيف أتواصل مع الدعم الفني؟",
            answer: "يمكنك مراسلتنا على البريد الإلكتروني: support@mersal.app",
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ThemeColors.text,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            answer,
            style: TextStyle(
              color: ThemeColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}