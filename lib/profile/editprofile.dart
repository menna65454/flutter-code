// ignore_for_file: prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Challeneges/Main_Page.dart';
import '../mainfeature/upload.dart';
import '../subtitle/page1.dart';
import 'history.dart';
import 'profilescreen.dart';

final supabase = Supabase.instance.client;

class Personalinfo extends StatefulWidget {
  const Personalinfo({super.key});

  @override
  State<Personalinfo> createState() => _PersonalinfoState();
}

class _PersonalinfoState extends State<Personalinfo> {
  int _selectedIndex = 0;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = Upload_Page();
        break;
      case 1:
        nextScreen = SubtitlePage();
        break;
      case 2:
        nextScreen = HomePage();
        break;
      case 3:
        nextScreen = ProfileScreen(); // تغيير الشاشة الأخيرة إذا لزم الأمر
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await supabase.from('profiles').select().eq('id', user.id).single();
    setState(() => userData = response);
  }

  Future<void> _updateProfile(
      String firstName,
      String lastName,
      String phoneNumber,
      String dateofbirth,
      String selectedGender,
      String? avatarUrl) async {
    //
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('profiles').update({
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'date_of_birth': dateofbirth,
      'gender': selectedGender,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', user.id);

    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // أضف هذا السطر لجعل الخلفية بيضاء
      appBar: AppBar(
        backgroundColor: Colors.white, // أضف هذا السطر لجعل الخلفية بيضاء

        title: const Text(
          'Personal Info',
          style: TextStyle(
            color: Color(0xFF0A4627),
            fontSize: 28,
            fontFamily: 'Inria Serif',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedImageUrl = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    userData: userData,
                    onUpdate: _updateProfile,
                  ),
                ),
              );

              if (updatedImageUrl != null) {
                setState(() {
                  userData!['avatar_url'] = updatedImageUrl;
                });
              }
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Inria Sans',
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (userData!['avatar_url'] != null &&
                                userData!['avatar_url'].isNotEmpty)
                            ? NetworkImage(
                                '${userData!['avatar_url']}?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                            : null,
                        child: (userData!['avatar_url'] == null ||
                                userData!['avatar_url'].isEmpty)
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        userData!['first_name'] ?? 'No Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        userData!['last_name'] ?? 'No Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.grey.shade200, // ✅ تغيير لون البطاقة

                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text(
                        'first Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      subtitle: Text(
                        userData!['first_name'] ?? 'No Name',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 152, 150, 150),
                          fontSize: 16,
                          fontFamily: 'Inria Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: Colors.grey.shade200, // ✅ تغيير لون البطاقة

                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text(
                        'last Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      subtitle: Text(
                        userData!['last_name'] ?? 'No Name',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 152, 150, 150),
                          fontSize: 16,
                          fontFamily: 'Inria Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: Colors.grey.shade200, // ✅ تغيير لون البطاقة

                    child: ListTile(
                        leading: const Icon(
                            Icons.calendar_month), // ✅ أيقونة الميلاد
                        title: const Text(
                          'Date of birth',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inria Serif',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        subtitle: Text(
                          userData!['date_of_birth'] != null
                              ? DateFormat('d MMMM yyyy').format(
                                  DateTime.parse(userData!['date_of_birth']))
                              : 'No date',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 152, 150, 150),
                            fontSize: 16,
                            fontFamily: 'Inria Sans',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        )),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: Colors.grey.shade200,
                    child: ListTile(
                      leading: const Icon(Icons.wc),
                      title: const Text(
                        'Gender',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      subtitle: Text(
                        userData!['gender'] ?? 'No Gender',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 152, 150, 150),
                          fontSize: 16,
                          fontFamily: 'Inria Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: Colors.grey.shade200, // ✅ تغيير لون البطاقة

                    child: ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text(
                        'Email Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      subtitle: Text(
                        userData!['email'],
                        style: const TextStyle(
                          color: Color(0xFF797979),
                          fontSize: 16,
                          fontFamily: 'Inria Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,

        currentIndex: _selectedIndex, // تعيين العنصر المحدد
        onTap: _onItemTapped, // استدعاء التنقل عند الضغط
        type: BottomNavigationBarType.fixed, // تجنب إعادة ترتيب الأيقونات
        items: [
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/deflip.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/defsubtitle.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/deflearn.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage(
                  "assets/profile.jpeg"), // تعديل الصورة إذا لزم الأمر
              radius: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final Function(String, String, String, String, String, String?) onUpdate;
//
  const EditProfileScreen(
      {super.key, required this.userData, required this.onUpdate});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int _selectedIndex = 0;

  File? _image;
  String? _imageUrl;
  String? selectedGender; // إما 'Male' أو 'Female'
// لتخزين رابط الصورة الحالية

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();

  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      _firstNameController.text = widget.userData!['first_name'] ?? '';

      _lastNameController.text = widget.userData!['last_name'] ?? '';
      _dateOfBirthController.text =
          widget.userData!['date_of_birth'] ?? ''; // ✅ تحميل تاريخ الميلاد
      _genderController.text = widget.userData!['gender'] ?? '';

      _phoneController.text = widget.userData!['phone_number'] ?? '';
      _imageUrl = widget.userData!['avatar_url']; // تحميل الصورة الحالية
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = Upload_Page();
        break;
      case 1:
        nextScreen = SubtitlePage();
        break;
      case 2:
        nextScreen = ProfileScreen();
        break;
      case 3:
        nextScreen = ProfileScreen(); // تغيير الشاشة الأخيرة إذا لزم الأمر
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final fileExt = imageFile.path.split('.').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${user.id}_$timestamp.$fileExt';
    final filePath = 'avatars/$fileName';

    try {
      // ✅ حذف الصورة القديمة (اختياري)
      final files =
          await supabase.storage.from('avatars').list(path: 'avatars/');
      for (var file in files) {
        if (file.name.startsWith(user.id)) {
          await supabase.storage
              .from('avatars')
              .remove(['avatars/${file.name}']);
          break;
        }
      }

      // ✅ رفع الصورة الجديدة باسم فريد
      final imageBytes = await imageFile.readAsBytes();
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            imageBytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      // ✅ الحصول على الرابط العام
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ جعل الخلفية بيضاء
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
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
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!) // صورة جديدة من الجهاز
                            : (_imageUrl != null
                                ? NetworkImage(
                                    '$_imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                                : null),
                        child: (_image == null &&
                                (_imageUrl == null || _imageUrl!.isEmpty))
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF0A4627),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ حقل الاسم

                Text(
                  'First Name',
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
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
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
                Text(
                  'last Name',
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
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
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
                Text(
                  'Date of Birth',
                  style: TextStyle(
                    color: Color(0xFF0C0C0C),
                    fontSize: 18,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _dateOfBirthController,
                  readOnly:
                      true, // ✅ منع الكتابة المباشرة وجعل الاختيار من خلال Date Picker
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateOfBirthController.text = "${pickedDate.toLocal()}"
                            .split(' ')[0]; // ✅ حفظ التاريخ بصيغة YYYY-MM-DD
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Gender',
                  style: TextStyle(
                    color: Color(0xFF0C0C0C),
                    fontSize: 18,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    // Female
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGender = 'Female'; // ✅ تحديث المتغير
                            _genderController.text = 'Female';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: selectedGender == 'Female'
                                    ? Colors.green
                                    : Colors.grey,
                                size: 14,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Female',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Male
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGender = 'Male'; // ✅ تحديث المتغير
                            _genderController.text = 'Male';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: selectedGender == 'Male'
                                    ? Colors.green
                                    : Colors.grey,
                                size: 14,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Male',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ✅ حقل رقم الهاتف

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
                      onPressed: () async {
                        String? imageUrl = _imageUrl;
                        if (_image != null) {
                          imageUrl = await _uploadImage(_image!);
                        }

                        await widget.onUpdate(
                          _firstNameController.text,
                          _lastNameController.text,
                          _phoneController.text,
                          _dateOfBirthController.text,
                          _genderController.text,
                          imageUrl,
                        );

                        setState(() {
                          _imageUrl = imageUrl;
                        });

                        if (mounted) {
                          Navigator.pop(context, imageUrl);
                        }
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
                        'Save Changes',
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,

        currentIndex: _selectedIndex, // تعيين العنصر المحدد
        onTap: _onItemTapped, // استدعاء التنقل عند الضغط
        type: BottomNavigationBarType.fixed, // تجنب إعادة ترتيب الأيقونات
        items: [
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/deflip.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/defsubtitle.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/deflearn.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage(
                  "assets/profile.jpeg"), // تعديل الصورة إذا لزم الأمر
              radius: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}

extension on String {
  get error => null;
}
