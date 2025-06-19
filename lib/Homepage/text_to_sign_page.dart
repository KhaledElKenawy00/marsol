import 'package:flutter/material.dart';
import 'package:mersal_app/theme/theme_colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gif/gif.dart';

import 'homepage.dart';

class TextToSignController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final isLoading = false.obs;
  final currentVideoPath = ''.obs;
  final historyList = <Map<String, dynamic>>[].obs;
  final currentLetterIndex = 0.obs;
  final isPlaying = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('translations')
            .orderBy('timestamp', descending: true)
            .get();

        historyList.value = snapshot.docs
            .map((doc) => {
          'id': doc.id,
          'text': doc['text'],
          'timestamp': doc['timestamp'],
        })
            .toList();
      }
    } catch (e) {
      print('Error loading history: $e');
    }
  }

  Future<void> saveToHistory(String text) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('translations')
            .add({
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        await loadHistory();
      }
    } catch (e) {
      print('Error saving to history: $e');
    }
  }

  Future<void> deleteFromHistory(String docId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('translations')
            .doc(docId)
            .delete();
        await loadHistory();
      }
    } catch (e) {
      print('Error deleting from history: $e');
    }
  }

  void clearText() {
    textController.clear();
    currentVideoPath.value = '';
    currentLetterIndex.value = 0;
    isPlaying.value = false;
  }

  String getLetterPath(String char) {
    if (char == 'أ' || char == 'ا') {
      return 'letters/أ.gif';
    }
    return 'letters/$char.gif';
  }

  void playNextLetter() {
    if (!isPlaying.value) return;

    if (currentLetterIndex.value < textController.text.length) {
      final char = textController.text[currentLetterIndex.value].toLowerCase();

      // Skip spaces and move to next character
      if (char == ' ') {
        currentLetterIndex.value++;
        playNextLetter();
        return;
      }

      // إعادة تعيين مسار الفيديو قبل تعيين المسار الجديد
      currentVideoPath.value = '';

      // تأخير قصير قبل تعيين المسار الجديد
      Future.delayed(const Duration(milliseconds: 50), () {
        if (isPlaying.value) {
          currentVideoPath.value = getLetterPath(char);
        }
      });

      // Schedule next letter after a delay
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (isPlaying.value) {
          currentLetterIndex.value++;
          if (currentLetterIndex.value < textController.text.length) {
            playNextLetter();
          } else {
            isPlaying.value = false;
            currentVideoPath.value = '';
          }
        }
      });
    } else {
      isPlaying.value = false;
      currentVideoPath.value = '';
    }
  }

  void translateText() async {
    if (textController.text.isEmpty) return;

    isLoading.value = true;
    try {
      // Save to history
      await saveToHistory(textController.text);

      // Reset playback
      currentLetterIndex.value = 0;
      isPlaying.value = true;
      currentVideoPath.value = '';

      // Start playing letters
      playNextLetter();
    } catch (e) {
      print('Error in translation: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showHistoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'السجلات',
                  style: TextStyle(
                    color: ThemeColors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final item = historyList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      shape: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                      title: Text(
                        item['text'],
                        style: TextStyle(color: ThemeColors.text),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteFromHistory(item['id']),
                      ),
                      onTap: () {
                        textController.text = item['text'];
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class GifPlayer extends StatefulWidget {
  final String gifPath;
  final bool isPlaying;

  const GifPlayer({
    Key? key,
    required this.gifPath,
    required this.isPlaying,
  }) : super(key: key);

  @override
  State<GifPlayer> createState() => _GifPlayerState();
}

class _GifPlayerState extends State<GifPlayer> with TickerProviderStateMixin {
  late final GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
  }

  @override
  void didUpdateWidget(GifPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.gifPath != oldWidget.gifPath) {
      _controller.reset();
      if (widget.isPlaying) {
        // تحسين مدة التشغيل وتكرار العرض
        _controller.repeat(
          min: 0,
          max: 1,
          period: const Duration(milliseconds: 2000),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Gif(
        image: AssetImage(widget.gifPath),
        controller: _controller,
        fit: BoxFit.contain,
        autostart: Autostart.once,
        placeholder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class TextToSignPage extends StatelessWidget {
  const TextToSignPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TextToSignController());

    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        backgroundColor: ThemeColors.background,
        title: Text(
          "النصوص",
          style: TextStyle(
            color: ThemeColors.primaryRed,
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
                  (route) => route.settings.name == '/home',
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: ThemeColors.text),
            onPressed: () => controller.showHistoryDialog(context),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Video display area
            Obx(() => Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: controller.currentVideoPath.value.isEmpty
                  ? Text(
                'سيظهر هنا الفيديو الناتج عن الترجمة',
                style: TextStyle(
                    color: ThemeColors.textinSTSG, fontSize: 18),
                textAlign: TextAlign.center,
              )
                  : GifPlayer(
                gifPath: controller.currentVideoPath.value,
                isPlaying: controller.isPlaying.value,
              ),
            )),
            const SizedBox(height: 24),
            Text(
              "أدخل النص للترجمة",
              style: TextStyle(
                color: ThemeColors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
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
              child: TextField(
                controller: controller.textController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "اكتب النص هنا...",
                  hintStyle: TextStyle(color: ThemeColors.secondaryText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: ThemeColors.cardBackground,
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: controller.clearText,
                  ),
                ),
                style: TextStyle(
                  color: ThemeColors.text,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.translateText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.primaryRed,
                  foregroundColor: ThemeColors.primaryRed,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(
                    color: ThemeColors.primaryOrange)
                    : const Text(
                  "ترجمة",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
