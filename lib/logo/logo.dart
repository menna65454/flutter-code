// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:login2/login/emailverification.dart';
import '../mainfeature/upload.dart';
import 'page1.dart'; // تأكد من استيراد الصفحة التالية

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      final user = supabase.auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Upload_Page()), // استبدل بـ الصفحة التالية
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Page1()), // استبدل بـ الصفحة التالية
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF0A4627),
              Color(0xFF24744B),
              Color(0xFF3CAB72),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 157,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo.jpeg"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'LIPIFY',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFEFEE3),
                fontSize: 36,
                fontFamily: 'Inknut Antiqua',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
