import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'phonemanger.dart';

class Changephonenumber extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const Changephonenumber({super.key, this.userData});

  @override
  State<Changephonenumber> createState() => _ChangephonenumberState();
}

class _ChangephonenumberState extends State<Changephonenumber> {
  // لتخزين رابط الصورة الحالية

  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      _phoneController.text = widget.userData!['phone_number'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ جعل الخلفية بيضاء
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
        backgroundColor: Colors.white, // ✅ جعل شريط التطبيق أبيض أيضًا
        elevation: 0, // ✅ إزالة الظل لجعل التصميم أنظف
        iconTheme:
            const IconThemeData(color: Colors.black), // تغيير لون أيقونة الرجوع
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          // ✅ التأكد من أن كل الخلفية بيضاء
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // محاذاة جميع العناصر لليسار

              children: [
                // ✅ الصورة الشخصية مع زر اختيار صورة جديدة

                const SizedBox(height: 20),

                // ✅ حقل الاسم
                Text(
                  'Old Phone Number',
                  style: TextStyle(
                    color: Color(0xFF0C0C0C),
                    fontSize: 18,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign:
                      TextAlign.left, // إضافة هذه السطر لمحاذاة النص لليسار
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_outlined),
                    hintText: 'Enter Your Old Phone Number',
                    hintStyle: TextStyle(
                      color: Color(0xFF0C0C0C),
                      fontSize: 18,
                      fontFamily: 'Inria Serif',
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ حقل رقم الهاتف
                Text(
                  'New Phone Number',
                  style: TextStyle(
                    color: Color(0xFF0C0C0C),
                    fontSize: 18,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left, // محاذاة النص لليسار
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_outlined),
                    hintText: 'Enter Your New Phone Number',
                    hintStyle: TextStyle(
                      color: Color(0xFF0C0C0C),
                      fontSize: 18,
                      fontFamily: 'Inria Serif',
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ زر الحفظ مع تدرج الألوان
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3CAB72),
                          Color(0xFF24744B),
                          Color(0xFF0A4627),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Phonemanger(
                                    phone: '',
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: const Text(
                        'Sent Code',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on String {
  get error => null;
}
