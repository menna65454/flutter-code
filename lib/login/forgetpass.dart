import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'emailverification.dart';
import 'resetpass.dart';

final supabase = Supabase.instance.client;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  reset_password() async {
    try {
      await supabase.auth.resetPasswordForEmail(
        _emailController.text, // فقط البريد الإلكتروني
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerification(
            email: _emailController.text,
          ),
        ),
      );
    } catch (e) {
      print("Error: $e");
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
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [
                        Color(0xFF0A4627),
                        Color(0xFF24744B),
                        Color(0xFF3CAB72),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 180),
                      Center(
                        child: Text(
                          'Forget Password',
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
                          'Mail Address here',
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
                          'Enter the email address associated with your account.',
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
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Color(0xFF0C0C0C),
                          fontSize: 18,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : reset_password,
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
                                "Recover Password",
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
