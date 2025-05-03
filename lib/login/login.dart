// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

import 'forgetpass.dart';
import 'signup_screen.dart';
import '../mainfeature/upload.dart';

final supabase = Supabase.instance.client;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 

  Future<void> _signInWithEmail() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (res.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully logged in!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Upload_Page()),
        );
      }
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     setState(() => _isLoading = true);
  //     await supabase.auth.signInWithOAuth(
  //       Provider.google,
  //       redirectTo: 'io.supabase.lipify://Upload_Page-callback/',
  //     );
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to sign in with Google')),
  //     );
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

//   Future<void> _signInWithFacebook() async {
//   try {
//     setState(() => _isLoading = true);
//     await supabase.auth.signInWithOAuth(
//       Provider.facebook,
//       redirectTo: 'io.supabase.lipify://LoginScreen-callback/',
//     );
//     debugPrint("Facebook login started...");
//   } on AuthException catch (error) {
//     debugPrint("Facebook Auth Error: ${error.message}");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Facebook Auth Error: ${error.message}')),
//     );
//   } catch (error) {
//     debugPrint("Unexpected error: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Unexpected error: $error')),
//     );
//   } finally {
//     if (mounted) setState(() => _isLoading = false);
//   }
// }

  
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
                  child: const SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 15),
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  color: Color(0xFFFEFEE3),
                                  fontSize: 40,
                                  fontFamily: 'Inria Serif',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 15),
                              Text(
                                'To our Lipify app',
                                style: TextStyle(
                                  color: Color(0xFFFEFEFE),
                                  fontSize: 20,
                                  fontFamily: 'Inria Serif',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
                          'Login',
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
                                ], // Gradient colors
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(Rect.fromLTRB(0, 0, 200,
                                  70)), // Adjust the Rect size accordingly
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              )),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Color(0xFF0C0C0C),
                          fontSize: 18,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w400,
                        ),
                        
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              )),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forget Password',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF0C0C0C),
                                fontSize: 14,
                                fontFamily: 'Inria Sans',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signInWithEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Make button background transparent
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets
                                .zero, // Remove default padding to allow for full gradient area
                          ).copyWith(
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF3CAB72),
                                  Color(0xFF24744B),
                                  Color(0xFF0A4627),
                                ],
                                // Gradient colors
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                  24), // Border radius to match the button's shape
                            ),
                            child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: double.infinity,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Color(0xFFFEFEFE),
                                          fontSize: 18,
                                          fontFamily: 'Inria Serif',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Or login with',
                                style: TextStyle(
                                  color: Color(0xFF797979),
                                  fontSize: 14,
                                  fontFamily: 'Inria Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialLoginButton(
                            Icons.g_mobiledata,
                            onPressed: (){}//_isLoading ? null : _signInWithGoogle,
                          ),
                          const SizedBox(width: 20),
                          _socialLoginButton(
                            Icons.facebook,
                            onPressed:(){}// _isLoading ? null : _signInWithFacebook,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?",
                              style: TextStyle(
                                color: Color(0xFF0C0C0C),
                                fontSize: 14,
                                fontFamily: 'Inria Sans',
                                fontWeight: FontWeight.w400,
                              )),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen()),
                                    );
                                  },
                            child: const Text('SignUp',
                                style: TextStyle(
                                  color: Color(0xFF24744B),
                                  fontSize: 16,
                                  fontFamily: 'Inria Sans',
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialLoginButton(IconData icon, {required VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: Colors.black87,
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
