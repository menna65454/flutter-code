import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login2/mainfeature/VideoPlayerScreen.dart'; // تأكد من أن هذا المسار صحيح
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  bool _isFrontCamera = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) return;
    _setCamera(_isFrontCamera);
  }

  Future<void> _setCamera(bool isFront) async {
    final selectedCamera = _cameras!.firstWhere(
      (camera) =>
          camera.lensDirection ==
          (isFront ? CameraLensDirection.front : CameraLensDirection.back),
    );

    _controller = CameraController(selectedCamera, ResolutionPreset.medium);
    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  // دالة لتبديل الكاميرا بين الأمامية والخلفية
  Future<void> _toggleCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    setState(() => _isFrontCamera = !_isFrontCamera);
    await _setCamera(_isFrontCamera);
  }

  Future<void> _startRecording() async {
    if (_controller == null || _controller!.value.isRecordingVideo) return;
    await _controller!.startVideoRecording();
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    // إيقاف التسجيل
    final file = await _controller!.stopVideoRecording();
    setState(() => _isRecording = false);

    // حفظ الفيديو في الكاش ثم رفعه
    String cachedPath = await _saveVideoToCache(file);

    // رفع الفيديو بعد حفظه في الكاش
    String responseText = await _uploadVideo(File(cachedPath));

    // عند إيقاف التسجيل، انتقل إلى صفحة الفيديو مع مسار الفيديو
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
            videoPath: cachedPath, responseText: responseText),
      ),
    );
  }

  // حفظ الفيديو في الكاش
  Future<String> _saveVideoToCache(XFile file) async {
    // الحصول على مسار الكاش
    final directory = await getTemporaryDirectory();
    final cacheDir = directory.path;
    final newPath = '$cacheDir/${DateTime.now().millisecondsSinceEpoch}.mp4';

    // نسخ الفيديو إلى الكاش
    final videoFile = await File(file.path).copy(newPath);
    print("Video saved to cache at: $newPath");

    return newPath; // إرجاع المسار الجديد للفيديو
  }

  // رفع الفيديو إلى API مع إرسال المسار
  Future<String> _uploadVideo(File videoFile) async {
    try {
      final uri = Uri.parse(
          'http://83fb-34-106-8-115.ngrok-free.app/predict'); // ضع رابط API هنا
      final request = http.MultipartRequest('POST', uri);

      // إضافة الفيديو كملف
      request.files
          .add(await http.MultipartFile.fromPath('video', videoFile.path));

      final response = await request.send();

      // التحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        return resBody; // إرجاع الرد من السيرفر
      } else {
        // في حالة فشل الرفع
        final errorResponse = await response.stream.bytesToString();
        print('Error response: $errorResponse');
        return 'فشل رفع الفيديو: ${response.statusCode} - $errorResponse';
      }
    } catch (e) {
      // التعامل مع أي استثناءات تحدث
      print('حدث خطأ أثناء رفع الفيديو: $e');
      return 'حدث خطأ أثناء رفع الفيديو: $e';
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Screen")),
      body: _controller == null || !_controller!.value.isInitialized
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: CameraPreview(_controller!)),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildControlButton(
                          Icons.autorenew_outlined, _toggleCamera),
                      SizedBox(width: 40),
                      buildControlButton(
                          null, _isRecording ? null : _startRecording,
                          isElevated: true),
                      SizedBox(width: 40),
                      buildControlButton(Icons.arrow_forward_ios,
                          _isRecording ? _stopRecording : null),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildControlButton(IconData? icon, VoidCallback? onPressed,
      {bool isElevated = false}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: isElevated
          ? ElevatedButton(onPressed: onPressed, child: Text(''))
          : IconButton(icon: Icon(icon), onPressed: onPressed, iconSize: 40.0),
    );
  }
}
