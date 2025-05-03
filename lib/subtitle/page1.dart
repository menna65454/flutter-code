// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:login2/profile/profilescreen.dart';
import 'package:login2/subtitle/uploadPage.dart';

import '../mainfeature/upload.dart';
import '../profile/editprofile.dart';

class SubtitlePage extends StatefulWidget {
  const SubtitlePage({super.key});

  @override
  State<SubtitlePage> createState() => _SubtitlePageState();
}

class _SubtitlePageState extends State<SubtitlePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String? avatarUrl;
  Map<String, dynamic>? userData;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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
        nextScreen = ProfileScreen();
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

  @override
  void initState() {
    super.initState();
    _fetchUserAvatar();
    _fetchUserData();

    // Animation init
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : const AssetImage('assets/default_avatar.jpeg')
                    as ImageProvider,
          ),
          title: userData == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Hi, ${userData!['first_name'] ?? ''}',
                        style: TextStyle(
                          color: Color(0xFF0C0C0C),
                          fontSize: 24,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
          actions: const [
            Icon(Icons.menu, size: 30, color: Color(0xFF0A4627)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Subtitle',
              style: TextStyle(
                color: Color(0xFF0A4627),
                fontSize: 32,
                fontFamily: 'Inria Serif',
                fontWeight: FontWeight.w700,
                height: 1.5,
                letterSpacing: -0.61,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSubtitleCard(
                  context,
                  "assets/sub_url.jpg",
                  "Enter URL of video",
                  onTap: () {},
                ),
                _buildSubtitleCard(
                  context,
                  "assets/sub_history.jpg",
                  "Select from history",
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: _buildSubtitleCard(
                context,
                "assets/sub_upload.jpg",
                "Upload from gallery",
                width: MediaQuery.of(context).size.width * 0.85,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPickerPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/deflip.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/subtitle.jpeg"),
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
              backgroundImage: AssetImage("assets/defprofile.jpeg"),
              radius: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitleCard(
    BuildContext context,
    String image,
    String label, {
    required VoidCallback onTap,
    double width = 140,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _animationController.reverse(),
        onTapUp: (_) {
          _animationController.forward();
          onTap();
        },
        onTapCancel: () => _animationController.forward(),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xFF0A4627),
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: Container(
            width: width,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/sub_arrow.jpg',
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Image.asset(
                  image,
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF0A4627),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}