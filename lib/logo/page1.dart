import 'package:flutter/material.dart';

import '../login/login.dart';
import '../mainfeature/upload.dart';
import 'page2.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
  
}

class _Page1State extends State<Page1> {
  
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
          color: const Color(0xFF744B5B),
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
                height: screenHeight * 0.65, // يجعل الصورة تغطي 60% من الشاشة
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg1.jpeg"),
                    fit: BoxFit.fill,
                  ),
                ),
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
                        const Text(
                          'The Power of Silence',
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
                        const Text(
                          'Our advanced lip-reading technology accurately decodes speech from video, making communication possible even in silence.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inria Sans',
                            fontWeight: FontWeight.w700, // تغيير الوزن إلى Bold
                            height: 1.50,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            backgroundColor: const Color(0xFF24744B),
                            radius: screenWidth * 0.012),
                        SizedBox(width: screenWidth * 0.02),
                        CircleAvatar(
                            backgroundColor: const Color(0xFFD9D9D9),
                            radius: screenWidth * 0.012),
                        SizedBox(width: screenWidth * 0.02),
                        CircleAvatar(
                            backgroundColor: const Color(0xFFD9D9D9),
                            radius: screenWidth * 0.012),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Page2(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: screenWidth * 0.1,
                        backgroundColor: const Color(0xFF24744B),
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
                  onPressed: () {Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );},
                  child: const Text(
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
