// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:login2/login/emailverification.dart';
import 'package:login2/subtitle/page1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

import '../profile/history.dart';

class ProcessedVideoPage extends StatefulWidget {
  final String videoUrl;

  const ProcessedVideoPage({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  State<ProcessedVideoPage> createState() => _ProcessedVideoPageState();
}

class _ProcessedVideoPageState extends State<ProcessedVideoPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Processed Video')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : CircularProgressIndicator(),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                            SizedBox(height: 50,),

                TextButton(
                  onPressed: () {
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubtitlePage(),
                    ),
                  );      
                  },
                 
                  child: Container(
                 height: 50,
                 width: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3CAB72),
                          Color(0xFF24744B),
                          Color(0xFF0A4627)
                        ],
                        
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    
                     
                          child:  Center(
                            child: Text(
                              'Try Again',
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

                TextButton(
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                 
                  child: Container(
                 height: 50,
                 width: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3CAB72),
                          Color(0xFF24744B),
                          Color(0xFF0A4627)
                        ],
                        
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                     
                          child:  Text(
                            'Done',
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
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) async {
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
                onPressed: () async {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubtitlePage(),
                    ),
                  ); 
                },
              ),
              TextButton(
                onPressed: () async {
                 final user = supabase.auth.currentUser;
    if (user != null) {
      await supabase.from('video_history').insert({
        'user_id': user.id,
        'video_url': widget.videoUrl,
      });

      // الانتقال إلى صفحة Subtitle بعد الحفظ
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryPage()),
      );
    } else {
      // في حالة المستخدم غير مسجل الدخول
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in first.')),
      );
    }
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
                      'Yes',
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
        actionsAlignment: MainAxisAlignment.spaceEvenly, // توزيع الأزرار بالتساوي
      );
    },
  );
}


}

extension on String {
  get error => null;
}
