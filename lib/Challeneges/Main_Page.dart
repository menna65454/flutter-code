// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:login2/Challeneges/Test_Page.dart';
import 'package:login2/Challeneges/Train_Page.dart';
import 'package:login2/login/signup_screen.dart';

import '../mainfeature/upload.dart';
import '../profile/profilescreen.dart';
import '../subtitle/page1.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? avatarUrl;
  Map<String, dynamic>? userData;
  int _selectedIndex = 0;

  @override
  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await supabase.from('profiles').select().eq('id', user.id).single();
    setState(() {
      userData = response;
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
        nextScreen = ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
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

  void initState() {
    super.initState();

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile section

                // Logo
                Row(
                  children: [
                    Text(
                      'LipTrack',
                      style: TextStyle(
                        color: Color(0xFF0A4627),
                        fontSize: 32,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                        letterSpacing: -0.61,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.help_outline, color: Colors.green[800]),
                  ],
                ),
                SizedBox(height: 16),

                // Title
                Text(
                  'What Would You Like To Do..',
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 16),

                // Learning Card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VideoLessonsApp()),
                    );
                  },
                  child: CardOption(
                    imageUrl: 'assets/learn.png',
                    title: '',
                  ),
                ),
                SizedBox(height: 16),

                // Test Yourself Card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChallengeScreen()),
                    );
                  },
                  child: CardOption(
                    imageUrl: 'assets/test.png',
                    title: '',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom navigation (optional placeholder)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
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
              backgroundImage: AssetImage("assets/learn.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/defprofile.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}

class CardOption extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CardOption({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
