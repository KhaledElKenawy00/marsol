import 'package:flutter/material.dart';
import 'package:mersal_app/Homepage/letter_video_page.dart';
import 'package:mersal_app/theme/theme_colors.dart';

class LettersPage extends StatefulWidget {
  const LettersPage({Key? key}) : super(key: key);

  @override
  State<LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<LettersPage> {
  final List<String> arabicLetters = [
    'أ',
    'ب',
    'ت',
    'ث',
    'ج',
    'ح',
    'خ',
    'د',
    'ذ',
    'ر',
    'ز',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ع',
    'غ',
    'ف',
    'ق',
    'ك',
    'ل',
    'م',
    'ن',
    'ه',
    'و',
    'ي'
  ];

  int activeLetterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'تعلم الحروف',
          style: TextStyle(
            color: ThemeColors.primaryRed,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'اختر الحرف الذي تريد تعلمه',
              style: TextStyle(
                color: ThemeColors.secondaryText,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: arabicLetters.length,
              itemBuilder: (context, index) {
                final isActive = index == activeLetterIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      activeLetterIndex = index;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LetterVideoPage(
                          letter: arabicLetters[index],
                          letterIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive
                          ? ThemeColors.primaryOrange
                          : ThemeColors.button,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isActive
                              ? ThemeColors.amberShadow
                              : ThemeColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        arabicLetters[index],
                        style: TextStyle(
                          color: ThemeColors.text,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
