
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:login2/login/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Challeneges/Main_Page.dart';
import 'editprofile.dart';
import 'history.dart';
import 'notification.dart';
import '../setting/setting.dart';
import '../mainfeature/upload.dart';
import '../subtitle/page1.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
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
    _fetchUserAvatar();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 🔹 جعل الخلفية بيضاء بالكامل
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  const Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.black, // 🔹 تغيير اللون إلى الأسود
                        fontSize: 24,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl!)
                              : const AssetImage('assets/default_avatar.png')
                                  as ImageProvider,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData!['first_name'] ?? 'No Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Inria Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildProfileMenuItem(
                          icon: Icons.person,
                          text: "Personal Info",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Personalinfo()),
                          ),
                        ),
                        _buildProfileMenuItem(
                          icon: Icons.notifications,
                          text: "Notification",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  NotificationsPage()),
                          ),
                        ),
                        _buildProfileMenuItem(
                          icon: Icons.history,
                          text: "History",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HistoryPage()),
                          ),
                        ),
                        _buildProfileMenuItem(
                          icon: Icons.settings,
                          text: "Setting",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          ),
                        ),
                        _buildLogoutMenuItem(
                            context), // عنصر تسجيل الخروج المخصص
                      ],
                    ),
                  ),
                ],
              ),
            ),
     bottomNavigationBar:BottomNavigationBar(
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
              backgroundImage: AssetImage("assets/profile.jpeg"), // تعديل الصورة إذا لزم الأمر
              radius: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black), // 🔹 أيقونات سوداء
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ), // 🔹 لون النص أسود
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 16, color: Colors.black), // 🔹 أيقونة السهم باللون الأسود
      onTap: onTap,
    );
  }

  Widget _buildLogoutMenuItem(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.black),
      title: Text(
        "Log Out",
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: () {
        _showLogoutConfirmationDialog(context);
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // تحديد شكل الحواف
          ),
          title: Text(
            'Log Out',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0C0C0C),
              fontSize: 24,
              fontFamily: 'Inria Serif',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inria Sans',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // إغلاق الـ AlertDialog
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.zero, // إزالة التباعد الداخلي لتنسيق أفضل
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 27),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3CAB72),
                          Color(0xFF24744B),
                          Color(0xFF0A4627)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFFFEFEFE),
                          fontSize: 18,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
               
                TextButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF24744B),
                        // ✅ لون الحدود
                        width: 1, // ✅ سمك الحدود
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                        child: Text(
                      'Yes,  Log Out',
                      style: TextStyle(
                        color: Color(0xFF0C0C0C),
                        fontSize: 18,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ),
                  style: ButtonStyle(),
                  onPressed: () async {
                    await supabase.auth.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()), // الرجوع إلى صفحة تسجيل الخروج
                    );
                  },
                ),
              ],
            ),
          ],
          actionsAlignment:
              MainAxisAlignment.spaceEvenly, // توزيع الأزرار بالتساوي
        );
      },
    );
  }
}
