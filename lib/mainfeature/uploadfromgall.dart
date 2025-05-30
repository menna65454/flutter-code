// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

import '../Challeneges/Main_Page.dart';
import '../profile/history.dart';
import '../profile/profilescreen.dart';
import '../subtitle/page1.dart';
import 'upload.dart';

class VideoPickerPage extends StatefulWidget {
  @override
  _VideoPickerPageState createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {
  int _selectedIndex = 0;
  VideoPlayerController? _controller;
  String? _videoPath;
  TextEditingController _responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pickVideo();
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
          _controller?.dispose();
          _controller = VideoPlayerController.file(File(_videoPath!))
            ..initialize().then((_) {
              setState(() {});
              _controller!.play();
            });
        });

        await _uploadVideoToServer(filePath);
      }
    }
  }

  Future<void> _uploadVideoToServer(String filePath) async {
    var uri = Uri.parse(
        "https://d116-35-198-234-167.ngrok-free.app/predict"); // غيّر الرابط حسب ngrok الجديد
    var request = http.MultipartRequest('POST', uri);

    final mimeType = lookupMimeType(filePath);
    final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

    var videoFile = await http.MultipartFile.fromPath(
      'video', // تأكد من تطابق الاسم مع اسم الحقل في السيرفر
      filePath,
      contentType: mediaType,
    );

    request.files.add(videoFile);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        final decoded = responseBody.contains("transcript")
            ? RegExp(r'"transcript"\s*:\s*"([^"]+)"')
                .firstMatch(responseBody)
                ?.group(1)
            : responseBody;

        setState(() {
          _responseController.text = decoded ?? "Empty response";
        });
      } else {
        var responseBody = await response.stream.bytesToString();
        setState(() {
          _responseController.text =
              "Failed to upload. Status: ${response.statusCode}\n$responseBody";
        });
      }
    } catch (e) {
      setState(() {
        _responseController.text = "Upload error: $e";
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = Upload_Page();
        break;
      case 1:
        nextScreen = SubtitlePage();
        break;
      case 2:
        nextScreen = HomePage();
        break;
      case 3:
        nextScreen = ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Icon(Icons.menu, size: 50, color: Color(0xFF0A4627)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: _controller != null && _controller!.value.isInitialized
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _responseController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Server Response',
                  hintText: 'The server response will be displayed here...',
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF24744B), width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Try again ',
                          style: TextStyle(
                            color: Color(0xFF0C0C0C),
                            fontSize: 18,
                            fontFamily: 'Inria Serif',
                          ),
                        ),
                        Icon(Icons.refresh_outlined),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                TextButton(
                  onPressed: () => _showLogoutConfirmationDialog(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF3CAB72),
                          Color(0xFF24744B),
                          Color(0xFF0A4627)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Done',
                          style: TextStyle(
                            color: Color(0xFFFEFEFE),
                            fontSize: 18,
                            fontFamily: 'Inria Serif',
                          ),
                        ),
                        Icon(Icons.check, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/lip.jpg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/defsubtitle.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/deflearn.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/defprofile.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(''),
          content: Text(
            'Would you like to save this video to your history?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inria Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Upload_Page()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 45),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF24744B),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF3CAB72),
                          Color(0xFF24744B),
                          Color(0xFF0A4627)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        color: Color(0xFFFEFEFE),
                        fontSize: 18,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
