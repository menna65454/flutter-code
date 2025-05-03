// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

import '../profile/history.dart';
import '../profile/profilescreen.dart';
import 'upload.dart';
import '../subtitle/page1.dart';


class VideoPickerPage extends StatefulWidget {
  @override
  _VideoPickerPageState createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {
      int _selectedIndex = 0;

  VideoPlayerController? _controller;
  String? _videoPath;

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

      // الحصول على المسار الفعلي للملف
      String? filePath = file.path;

      if (filePath != null) {
        setState(() {
          _videoPath = filePath;
          _controller?.dispose(); // تنظيف الموارد السابقة
          _controller = VideoPlayerController.file(
            File(_videoPath!),
          )..initialize().then((_) {
              setState(() {});
              _controller!.play(); // تشغيل الفيديو تلقائيًا بعد التحميل
            });
        });
      }
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
        nextScreen = ProfileScreen();
        break;
      case 3:
        nextScreen = ProfileScreen(); // تغيير الشاشة الأخيرة إذا لزم الأمر
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
          Icon(
            Icons.menu,
            size: 50,
            color: Color(0xFF0A4627)
          )
        ],),      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
             child: _controller != null && _controller!.value.isInitialized
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30), // ✅ اجعل الأطراف دائرية
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                )
              : CircularProgressIndicator(), // مؤشر تحميل أثناء التحميل
        ),
            SizedBox(
              height: 40,
            ),
            Container(
                padding: EdgeInsets.all(20),
                decoration: ShapeDecoration(
                   color:  Color(0xFFEDEDED),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                width: 360,
                height: 100,
                child: Text("")),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                TextButton(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF24744B),
                        // ✅ لون الحدود
                        width: 1, // ✅ سمك الحدود
                      ),
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
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.refresh_outlined)),
                      ],
                    ),
                  ),
                  style: ButtonStyle(),
                  onPressed: () {
                    // Add delete account logic here
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // إغلاق الـ AlertDialog
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.zero, // إزالة التباعد الداخلي لتنسيق أفضل
                    ),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
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
                    child: Center(
                      child: Row(
                        children: [
                          const Text(
                            'Done',
                            style: TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 18,
                              fontFamily: 'Inria Serif',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _showLogoutConfirmationDialog(context);
                              },
                              icon: const Icon(color: Colors.white, Icons.check)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 70,)
          ],
          
        ),
        
      ),
     bottomNavigationBar:BottomNavigationBar(
              backgroundColor: Colors.white,

        currentIndex: _selectedIndex, // تعيين العنصر المحدد
        onTap: _onItemTapped, // استدعاء التنقل عند الضغط
        type: BottomNavigationBarType.fixed, // تجنب إعادة ترتيب الأيقونات
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
              backgroundImage: AssetImage("assets/defprofile.jpeg"), // تعديل الصورة إذا لزم الأمر
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // تحديد شكل الحواف
          ),
          title: Text(''),
          content: Text(
            'Would you like to save this video to your history?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inria Sans',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 45),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF24744B),
                        // ✅ لون الحدود
                        width: 1, // ✅ سمك الحدود
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                        child: Text(
                      'No',
                      style: TextStyle(
                        color: Color(0xFF0C0C0C),
                        fontSize: 18,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ),
                  style: ButtonStyle(),
                  onPressed: () async {Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               Upload_Page()),
                                    );},
                ),
                TextButton(
                  onPressed: () {
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.zero, // إزالة التباعد الداخلي لتنسيق أفضل
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 45),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
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
                    child: const Center(
                      child: Text(
                        'yes',
                        style: TextStyle(
                          color: Color(0xFFFEFEFE),
                          fontSize: 18,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsAlignment:
              MainAxisAlignment.spaceEvenly, // توزيع الأزرار بالتساوي
        );
      },
    );
  }
}
