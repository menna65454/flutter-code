// // ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:login2/profile/profilescreen.dart';

// import '../profile/editprofile.dart';
// import '../subtitle/page1.dart';
// import 'camerascreen.dart';
// import 'uploadfromgall.dart';

// class Upload_Page extends StatefulWidget {
//   Upload_Page({super.key});

//   @override
//   State<Upload_Page> createState() => _Upload_PageState();
// }

// class _Upload_PageState extends State<Upload_Page> {
//   int _selectedIndex = 0;
//   String? avatarUrl;
//   Map<String, dynamic>? userData;

//   Future<void> _fetchUserData() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return;

//     final response =
//         await supabase.from('profiles').select().eq('id', user.id).single();
//     setState(() {
//       userData = response;
//     });
//   }

//   String getFirstName(String fullName) {
//     // تقسيم النص إلى كلمات واستخراج أول كلمة
//     return fullName.split(' ')[0];
//   }

//   Future<void> checkAndInsertWelcomeNotification() async {
//     final userId = supabase.auth.currentUser?.id;

//     if (userId == null) return;

//     // تحقق إذا كان الإشعار موجود بالفعل
//     final response = await supabase
//         .from('notifications')
//         .select()
//         .eq('user_id', userId)
//         .eq('title', 'Welcome')
//         .limit(1);

//     final existing = response;

//     // إذا لم يكن موجود → أضفه
//     if (existing.isEmpty) {
//       await supabase.from('notifications').insert({
//         'user_id': userId,
//         'title': 'Welcome',
//         'body': 'Would you want to complete your profile ?',
//         'is_read': false,
//       });
//     }
//   }

//   Future<void> _fetchUserAvatar() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return;

//     final response = await supabase
//         .from('profiles')
//         .select('avatar_url')
//         .eq('id', user.id)
//         .single();

//     setState(() {
//       avatarUrl = response['avatar_url'];
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     Widget nextScreen;
//     switch (index) {
//       case 0:
//         nextScreen = Upload_Page();
//         break;
//       case 1:
//         nextScreen = SubtitlePage();
//         break;
//       case 2:
//         nextScreen = ProfileScreen();
//         break;
//       case 3:
//         nextScreen = ProfileScreen(); // تغيير الشاشة الأخيرة إذا لزم الأمر
//         break;
//       default:
//         return;
//     }

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => nextScreen),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();

//     checkAndInsertWelcomeNotification();
//     _fetchUserAvatar();
//     _fetchUserData();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.0), // تعديل الارتفاع حسب الحاجة

//         child: AppBar(
//           backgroundColor: Colors.white,
//           leading: PreferredSize(
//             preferredSize: Size(150, 150), // تغيير حجم الـ leading يدويًا
//             child: CircleAvatar(
//               radius: 500,
//               backgroundImage: avatarUrl != null
//                   ? NetworkImage(avatarUrl!)
//                   : const AssetImage('assets/default_avatar.jpeg')
//                       as ImageProvider,
//             ),
//           ),
//           title: userData == null
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Hi , ${(userData!['first_name'] ?? '')}',
//                         style: TextStyle(
//                           color: Color(0xFF0C0C0C),
//                           fontSize: 30,
//                           fontFamily: 'Inria Serif',
//                           fontWeight: FontWeight.w500,
//                           height: 1.50,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//           actions: [Icon(Icons.menu, size: 50, color: Color(0xFF0A4627))],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 SizedBox(
//                   height: 70,
//                 ),
//                 Text(
//                   'Lip Reading',
//                   style: TextStyle(
//                     color: Color(0xFF0A4627),
//                     fontSize: 32,
//                     fontFamily: 'Inria Serif',
//                     fontWeight: FontWeight.w700,
//                     height: 1.50,
//                     letterSpacing: -0.61,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               child: Column(
//                 children: [
//                   Image.asset(
//                     "assets/upload.jpeg",
//                     width: 380,
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               child: TextButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         backgroundColor: Colors.white,
//                         title: Text(
//                           "How would you like to upload your video?",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                         actions: [
//                           Container(
//                             color: Colors.grey[100],
//                             child: _buildOption(
//                               context,
//                               'From Gallery',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => VideoPickerPage()),
//                                 );
//                               },
//                             ),
//                           ),
//                           Container(
//                             color: Colors.grey[100],
//                             child: _buildOption(
//                               context,
//                               'Open Camera',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CameraScreen()),
//                                 );
//                                 // Handle camera selection
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.symmetric(vertical: 5),
//                             decoration: BoxDecoration(
//                               color: const Color.fromARGB(255, 233, 230, 230),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Container(
//                                   width: double.infinity,
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 5),
//                                   decoration: BoxDecoration(
//                                     color: const Color.fromARGB(
//                                         255, 233, 230, 230),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     'Exit',
//                                     style: TextStyle(
//                                       color: Colors.red,
//                                       fontSize: 16,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   )),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Text(
//                   'Upload',
//                   style: TextStyle(
//                     color: Color(0xFFFEFEFE),
//                     fontSize: 15,
//                     fontFamily: 'Inria Serif',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               width: 320,
//               height: 50,
//               padding: const EdgeInsets.all(8),
//               decoration: ShapeDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment(-1.00, -0.00),
//                   end: Alignment(1, 0),
//                   colors: [Color(0xFF3CAB72), Color(0xFF0A4627)],
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 shadows: [
//                   BoxShadow(
//                     color: Color(0x26000000),
//                     blurRadius: 2,
//                     offset: Offset(2, 2),
//                     spreadRadius: 0,
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,

//         currentIndex: _selectedIndex, // تعيين العنصر المحدد
//         onTap: _onItemTapped, // استدعاء التنقل عند الضغط
//         type: BottomNavigationBarType.fixed, // تجنب إعادة ترتيب الأيقونات
//         items: [
//           BottomNavigationBarItem(
//             icon: CircleAvatar(
//               backgroundImage: AssetImage("assets/lip.jpg"),
//               radius: 30,
//             ),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             icon: CircleAvatar(
//               backgroundImage: AssetImage("assets/defsubtitle.jpeg"),
//               radius: 30,
//             ),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             icon: CircleAvatar(
//               backgroundImage: AssetImage("assets/deflearn.jpeg"),
//               radius: 30,
//             ),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             icon: CircleAvatar(
//               backgroundImage: AssetImage(
//                   "assets/defprofile.jpeg"), // تعديل الصورة إذا لزم الأمر
//               radius: 30,
//             ),
//             label: "",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOption(BuildContext context, String text,
//       {bool isExit = false, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: const Color.fromARGB(255, 241, 237, 237),
//             // ✅ لون الحدود
//             width: 1, // ✅ سمك الحدود
//           ),
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isExit ? Colors.red : Colors.blue,
//             fontSize: 16,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:login2/profile/profilescreen.dart';

import '../Challeneges/Main_Page.dart';
import '../profile/editprofile.dart';
import '../subtitle/page1.dart';
import 'camerascreen.dart';
import 'uploadfromgall.dart';

class Upload_Page extends StatefulWidget {
  Upload_Page({super.key});

  @override
  State<Upload_Page> createState() => _Upload_PageState();
}

class _Upload_PageState extends State<Upload_Page> {
  int _selectedIndex = 0;
  String? avatarUrl;
  Map<String, dynamic>? userData;

  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await supabase.from('profiles').select().eq('id', user.id).single();
    setState(() {
      userData = response;
    });
  }

  String getFirstName(String fullName) {
    // تقسيم النص إلى كلمات واستخراج أول كلمة
    return fullName.split(' ')[0];
  }

  Future<void> checkAndInsertWelcomeNotification() async {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return;

    // تحقق إذا كان الإشعار موجود بالفعل
    final response = await supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('title', 'Welcome')
        .limit(1);

    final existing = response;

    // إذا لم يكن موجود → أضفه
    if (existing.isEmpty) {
      await supabase.from('notifications').insert({
        'user_id': userId,
        'title': 'Welcome',
        'body': 'Would you want to complete your profile ?',
        'is_read': false,
      });
    }
  }

  Future<void> _fetchUserAvatar() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('profiles')
        .select('avatar_url')
        .eq('id', user.id)
        .single();

    setState(() {
      avatarUrl = response['avatar_url'];
    });
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

  @override
  void initState() {
    super.initState();
    checkAndInsertWelcomeNotification();

    _fetchUserAvatar();
    _fetchUserData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // تعديل الارتفاع حسب الحاجة

        child: AppBar(
          backgroundColor: Colors.white,
          leading: PreferredSize(
            preferredSize: Size(150, 150), // تغيير حجم الـ leading يدويًا
            child: CircleAvatar(
              radius: 500,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : const AssetImage('assets/default_avatar.jpeg')
                      as ImageProvider,
            ),
          ),
          title: userData == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Hi , ${(userData!['first_name'] ?? '')}',
                        style: TextStyle(
                          color: Color(0xFF0C0C0C),
                          fontSize: 30,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),
          actions: [Icon(Icons.menu, size: 50, color: Color(0xFF0A4627))],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  height: 70,
                ),
                Text(
                  'Lip Reading',
                  style: TextStyle(
                    color: Color(0xFF0A4627),
                    fontSize: 32,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                    letterSpacing: -0.61,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    "assets/upload.jpeg",
                    width: 380,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          "How would you like to upload your video?",
                          style: TextStyle(fontSize: 20),
                        ),
                        actions: [
                          Container(
                            color: Colors.grey[100],
                            child: _buildOption(
                              context,
                              'From Gallery',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoPickerPage()),
                                );
                              },
                            ),
                          ),
                          Container(
                            color: Colors.grey[100],
                            child: _buildOption(
                              context,
                              'Open Camera',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CameraScreen()),
                                );
                                // Handle camera selection
                              },
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 233, 230, 230),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 233, 230, 230),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Exit',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Upload',
                  style: TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 15,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              width: 320,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.00, -0.00),
                  end: Alignment(1, 0),
                  colors: [Color(0xFF3CAB72), Color(0xFF0A4627)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 2,
                    offset: Offset(2, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
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
              backgroundImage: AssetImage("assets/lip.jpg"),
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
                  "assets/defprofile.jpeg"), // تعديل الصورة إذا لزم الأمر
              radius: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String text,
      {bool isExit = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 241, 237, 237),
            // ✅ لون الحدود
            width: 1, // ✅ سمك الحدود
          ),
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isExit ? Colors.red : Colors.blue,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
