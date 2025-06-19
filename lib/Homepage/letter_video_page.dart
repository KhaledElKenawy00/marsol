import 'package:flutter/material.dart';
import 'package:mersal_app/theme/theme_colors.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';

class LetterVideoPage extends StatefulWidget {
  final String letter;
  final int letterIndex;

  const LetterVideoPage({
    Key? key,
    required this.letter,
    required this.letterIndex,
  }) : super(key: key);

  @override
  State<LetterVideoPage> createState() => _LetterVideoPageState();
}

class _LetterVideoPageState extends State<LetterVideoPage>
    with TickerProviderStateMixin {
  final RxBool isPlaying = false.obs;
  late final GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    isPlaying.toggle();
    if (isPlaying.value) {
      _controller.repeat(
          min: 0, max: 1, period: const Duration(milliseconds: 1500));
    } else {
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: ThemeColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'حرف ${widget.letter}',
              style: TextStyle(
                color: ThemeColors.primaryRed,
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
          body: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ThemeColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Gif(
                    image: AssetImage('letters/${widget.letter}.gif'),
                    controller: _controller,
                    fit: BoxFit.contain,
                    autostart: Autostart.once,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() => IconButton(
                          icon: Icon(
                            isPlaying.value ? Icons.pause : Icons.play_arrow,
                            size: 50,
                            color: ThemeColors.primaryOrange,
                          ),
                          onPressed: _togglePlay,
                        )),
                    ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          'اختبار',
                          'سيتم إضافة اختبار قريباً',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: ThemeColors.primaryOrange,
                          colorText: ThemeColors.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'اختبار',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
