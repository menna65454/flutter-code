// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'login.dart';
import '../mainfeature/upload.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/success.jpeg',
                width: 300,
                height: 300,
              ),
            ),
          ),
          const Text(
            'You Have Created Your Account Successfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inria Serif',
              fontWeight: FontWeight.w400,
              height: 1.50,
              letterSpacing: -0.34,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3CAB72),
                      Color(0xFF24744B),
                      Color(0xFF0A4627),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: double.infinity,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Color(0xFFFEFEFE),
                        fontSize: 18,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
