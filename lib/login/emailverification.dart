// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:login2/setting/passwordmanger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'resetpass.dart';

final supabase = Supabase.instance.client;

class EmailVerification extends StatefulWidget {
  final String email;

  const EmailVerification({super.key, required this.email});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = _codeControllers.map((c) => c.text).join();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete code')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      // تحقق من الكود عبر Supabase
      final response = await supabase.auth.verifyOTP(
        email: widget.email,
        token: code,
        type: OtpType.recovery, // نوع OTP المستخدم لاستعادة كلمة المرور
      );

      if (response.session != null) {
        // إذا كان الكود صحيحًا، انتقل إلى شاشة إعادة تعيين كلمة المرور
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ResetPassword(email: widget.email),
          ));
          
        }
      } else {
        throw Exception('Invalid code');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid verification code')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    try {
      setState(() => _isLoading = true);
      await supabase.auth.resetPasswordForEmail(widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New code sent successfully')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to resend code')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 812,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Stack(
            children: [
              
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 180),
                      Center(
                        child: Text(
                          'Email Verification',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Inria Serif',
                            fontWeight: FontWeight.w700,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  Color(0xFF0A4627),
                                  Color(0xFF24744B),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(Rect.fromLTRB(0, 0, 200, 70)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Get Your Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0C0C0C),
                            fontSize: 20,
                            fontFamily: 'Inria Serif',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Please enter the 6-digit code that was sent to your email address',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF797979),
                            fontSize: 16,
                            fontFamily: 'Inria Serif',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                          (index) => SizedBox(
                            width: 50,
                            child: TextField(
                              controller: _codeControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "If you don't receive code ",
                            style: TextStyle(
                              color: Color(0xFF797979),
                              fontSize: 16,
                              fontFamily: 'Inria Serif',
                            ),
                          ),
                          TextButton(
                            onPressed: _isLoading ? null : _resendCode,
                            child: Text(
                              'Resend It',
                              style: TextStyle(
                                color: Color(0xFF24744B),
                                fontSize: 16,
                                fontFamily: 'Inria Serif',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _verifyCode,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            side: MaterialStateProperty.all(
                              BorderSide(color: Colors.white, width: 2),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
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
                                "Verify",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Inria Serif',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.08,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
