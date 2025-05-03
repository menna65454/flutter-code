import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class Phonemanger extends StatefulWidget {
  final String phone;

  const Phonemanger({super.key, required this.phone});

  @override
  State<Phonemanger> createState() => _PhonemangerState();
}

class _PhonemangerState extends State<Phonemanger> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phone Manager',
          style: TextStyle(
            color: Color(0xFF0A4627),
            fontSize: 28,
            fontFamily: 'Inria Serif',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
      ),
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
                      const SizedBox(height: 30),
                      
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
                            onPressed:
                                () {}, // _isLoading ? null : _resendCode,
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
                          onPressed: () {}, //_isLoading ? null : _verifyCode,
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
