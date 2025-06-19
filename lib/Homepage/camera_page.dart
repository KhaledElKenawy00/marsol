import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  bool _isFrontCamera = false;
  bool _isLoading = false;
  String _detectedText = "";
  bool _showDetectedText = false;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("ar-SA");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _initCamera() async {
    setState(() => _isLoading = true);
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception("No cameras available");

      _controller = CameraController(
        _isFrontCamera
            ? cameras
                .firstWhere((c) => c.lensDirection == CameraLensDirection.front)
            : cameras
                .firstWhere((c) => c.lensDirection == CameraLensDirection.back),
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller?.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar("خطأ", "فشل في تشغيل الكاميرا");
    }
  }

  Future<void> _startDetection() async {
    if (!_isCameraInitialized) return;

    setState(() {
      _isDetecting = true;
      _showDetectedText = false;
    });

    Get.snackbar(
      "",
      "جاري بدء الكشف...",
      duration: Duration(seconds: 1),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _detectedText = "مرحبًا بك في تطبيق ترجمة لغة الإشارة";
      _showDetectedText = true;
    });
  }

  Future<void> _stopDetection() async {
    bool confirm = await Get.dialog<bool>(
          AlertDialog(
            title: Text("تأكيد الإيقاف",
                style: TextStyle(fontWeight: FontWeight.bold)),
            content:
                Text("هل أنت متأكد من إيقاف الكشف؟ سيتم إيقاف عملية الترجمة."),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text("إلغاء", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text("تأكيد الإيقاف",
                    style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      setState(() => _isDetecting = false);
      Get.snackbar(
        "",
        "تم إيقاف الكشف",
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _translateText() async {
    if (_detectedText.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "لا يوجد نص للترجمة",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _detectedText = _detectedText == "مرحبًا بك في تطبيق ترجمة لغة الإشارة"
          ? "Welcome to Sign Language Translation App"
          : "مرحبًا بك في تطبيق ترجمة لغة الإشارة";
    });

    Get.snackbar(
      "",
      "تمت الترجمة بنجاح",
      duration: Duration(seconds: 1),
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Future<void> _speakText() async {
    if (_detectedText.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "لا يوجد نص للقراءة",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    await _flutterTts.speak(_detectedText);
  }

  Future<void> _shareText() async {
    if (_detectedText.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "لا يوجد نص للمشاركة",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await Share.share(_detectedText);
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "فشل في المشاركة",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _resetText() async {
    bool confirm = await Get.dialog<bool>(
          AlertDialog(
            title: Text("تأكيد المسح",
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text("هل أنت متأكد من مسح النص المكتشف بالكامل؟"),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text("إلغاء", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child:
                    Text("تأكيد المسح", style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      setState(() {
        _detectedText = "";
        _showDetectedText = false;
      });
      Get.snackbar(
        "",
        "تم مسح النص بنجاح",
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void _deleteLastChar() {
    if (_detectedText.isNotEmpty) {
      setState(() {
        _detectedText = _detectedText.substring(0, _detectedText.length - 1);
        if (_detectedText.isEmpty) _showDetectedText = false;
      });
      Get.snackbar(
        "",
        "تم حذف آخر حرف",
        duration: Duration(milliseconds: 800),
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _toggleCamera() async {
    if (!_isCameraInitialized || _isLoading) return;
    setState(() => _isFrontCamera = !_isFrontCamera);
    await _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'ترجمة لغة الإشارة',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'الجملة المكتشفة:\nقم بالإشارة أمام الكاميرا للترجمة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _isCameraInitialized
                        ? CameraPreview(_controller!)
                        : Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _showDetectedText ? 100 : 0,
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.symmetric(vertical: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _detectedText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isDetecting ? _stopDetection : _startDetection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDetecting ? Colors.red : Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      _isDetecting ? Icons.stop : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: Text(
                      _isDetecting ? 'إيقاف الكشف' : 'بدء الكشف',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.share,
                    label: 'مشاركة',
                    onPressed: _shareText,
                    color: Colors.blue,
                  ),
                  _buildActionButton(
                    icon: Icons.translate,
                    label: 'ترجمة',
                    onPressed: _translateText,
                    color: Colors.purple,
                  ),
                  _buildActionButton(
                    icon: Icons.volume_up,
                    label: 'قراءة',
                    onPressed: _speakText,
                    color: Colors.indigo,
                  ),
                  _buildActionButton(
                    icon: Icons.backspace,
                    label: 'حذف حرف',
                    onPressed: _deleteLastChar,
                    color: Colors.orange,
                  ),
                  _buildActionButton(
                    icon: Icons.replay,
                    label: 'مسح الكل',
                    onPressed: _resetText,
                    color: Colors.red,
                  ),
                  _buildActionButton(
                    icon:
                        _isFrontCamera ? Icons.camera_rear : Icons.camera_front,
                    label: 'تبديل',
                    onPressed: _toggleCamera,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Function() onPressed,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 28),
          color: color,
          onPressed: onPressed,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
