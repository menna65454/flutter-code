// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../login/login.dart';
import 'page3.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color.fromARGB(255, 41, 40, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.6, // يجعل الصورة تغطي 60% من الشاشة
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg2.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              left:
                  MediaQuery.of(context).size.width * 0.05, // تحديد الموقع يسار
              top: MediaQuery.of(context).size.height *
                  0.08, // تحديد الموقع أعلى
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              left: 0,
              top: screenHeight * 0.5,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.5, // النصف السفلي من الشاشة
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.05,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFEFEFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(150),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Automatic Subtitles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0A4627),
                            fontSize: 24,
                            fontFamily: 'Inria Serif',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Enjoy videos with auto-generated subtitles in multiple languages, ensuring you never miss a word.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inria Sans',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                            radius: screenWidth * 0.012),
                        SizedBox(width: screenWidth * 0.02),
                        CircleAvatar(
                            backgroundColor: Color(0xFF24744B),
                            radius: screenWidth * 0.012),
                        SizedBox(width: screenWidth * 0.02),
                        CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                            radius: screenWidth * 0.012),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Page3(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: screenWidth * 0.1,
                        backgroundColor: Color(0xFF24744B),
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: screenWidth * 0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: screenWidth * 0.05,
              top: screenHeight * 0.08,
              child: TextButton(
                  onPressed: () { Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );},
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 20,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
