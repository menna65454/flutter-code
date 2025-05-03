import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import 'process.dart';

class VideoPickerPage extends StatefulWidget {
  @override
  _VideoPickerPageState createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {
  VideoPlayerController? _controller;
  String? _videoPath;
  String? _selectedLanguage;
  final List<String> _languages = ['English', 'Türkçe', 'Español'];


  @override
  void initState() {
    super.initState();
    _pickVideo(); // اختيار الفيديو مباشرة عند فتح الصفحة
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      String? filePath = file.path;

      if (filePath != null) {
        setState(() {
          _videoPath = filePath;
          _controller?.dispose(); // تنظيف الموارد السابقة
          _controller = VideoPlayerController.file(File(_videoPath!))
            ..initialize().then((_) {
              setState(() {});
              _controller!.play(); // تشغيل الفيديو تلقائيًا
            });
        });
      }
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
      appBar: AppBar(
        title: Text('Play Selected Video'),
        backgroundColor: Color(0xFF3CAB72),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _controller != null && _controller!.value.isInitialized
                  ? Column(
                      children: [
                        AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _controller!.value.isPlaying
                                  ? _controller!.pause()
                                  : _controller!.play();
                            });
                          },
                          child: Text(_controller!.value.isPlaying
                              ? 'Pause Video'
                              : 'Play Video'),
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),

            SizedBox(height: 30),

            // ✅ مكان اللغة: تحت الفيديو وعلى الشمال
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Language: ",
                  style: TextStyle(fontSize: 18),
                ),
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return _languages.map((String language) {
                      return PopupMenuItem<String>(
                        value: language,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: _selectedLanguage == language
                                ? Colors.yellow[200]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            language,
                            style: TextStyle(
                              fontWeight: _selectedLanguage == language
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_drop_down),
                      Text(
                        _selectedLanguage ?? 'Choose',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),

            // ✅ زر Start
            Center(
              child: ElevatedButton(
                onPressed: () async {
  if (_videoPath == null || _selectedLanguage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select a video and choose a language.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://a300-35-245-172-127.ngrok-free.app/generate_subtitles'),
  );

  request.files.add(await http.MultipartFile.fromPath('file', _videoPath!));
  request.fields['language'] = _selectedLanguage == 'English'
      ? 'en-US'
      : _selectedLanguage == 'Türkçe'
          ? 'tr'
          : 'es'; // Add more if needed

  var response = await request.send();
final respStr = await response.stream.bytesToString();
print('🔴 Response Code: ${response.statusCode}');
print('🔴 Response Body: $respStr');
  if (response.statusCode == 200) {
    final data = jsonDecode(respStr);
    final videoUrl = data['download_link'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessedVideoPage(videoUrl: videoUrl),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Video processing failed.:$respStr'),
        backgroundColor: Colors.red,
      ),
    );
  }
},

                               
                  //{
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content:
                  //           Text('Processing video in $_selectedLanguage...'),
                  //       backgroundColor: Colors.green,
                  //     ),
                  //   );
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(
                  //           'Please select a video and choose a language.'),
                  //       backgroundColor: Colors.red,
                  //     ),
                  //   );
                  
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Color(0xFF3CAB72),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}