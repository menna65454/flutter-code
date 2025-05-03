// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// import 'passwordmanger.dart';
// import 'phonemanger.dart';
// import 'phonemanger2.dart';

// class SettingsPage extends StatelessWidget {
//   @override
//   void _showDeleteConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Account'),
//           content: Text('Are you sure you want to delete your account?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel', style: TextStyle(color: Colors.green)),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Dismiss the dialog
//               },
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.green,
//                 side: BorderSide(color: Colors.green),
//               ),
//               child: Text('Yes, Delete it', style: TextStyle(color: Colors.green)),
//               onPressed: () {
//                 // Add delete account logic here
//                 Navigator.of(context).pop(); // Dismiss the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // 🔹 خلفية بيضاء بالكامل
//       appBar: AppBar(
//         title: Text('Settings'),
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(color: Colors.black),
//         elevation: 0, // 🔹 إزالة الظل من الـ AppBar
//         titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
//       ),
//       body: ListView(
//         children: [
//           _buildSettingItem(
//             context,
//             icon: Icons.lock,
//             title: 'Password Manager',
//             page: PasswordManager(),
//           ),
//           _buildSettingItem(
//             context,
//             icon: Icons.phone,
//             title: 'Phone Manager',
//             page: Changephonenumber(),
//           ),
//    _buildSettingItem(
//   context,
//   icon: Icons.delete,
//   title: 'Delete Account',
//   page: _showDeleteConfirmationDialog, // ✅ بدون أقواس
// ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingItem(BuildContext context,
//       {required IconData icon, required String title, required Widget page}) {
//     return Card(
//       elevation: 0, // 🔹 إزالة الظل
//       color: Colors.white, // 🔹 لون الخلفية أبيض
//       child: ListTile(
//         leading: Icon(icon, color: Colors.black),
//         title: Text(title, style: TextStyle(color: Colors.black)),
//         trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => page),
//         ),
//       ),
//     );
//   }
// }

// // صفحات فارغة لتجنب الأخطاء
// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

import 'passwordmanger.dart';
import 'phonemanger.dart';
import 'phonemanger2.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        titleTextStyle: TextStyle(color: Color(0xFF0A4627), fontSize: 20),
      ),
      body: ListView(
        children: [
          _buildSettingItem(
            context,
            icon: Icons.lock,
            title: 'Password Manager',
            page: PasswordManager(),
          ),
          _buildSettingItem(
            context,
            icon: Icons.phone,
            title: 'Phone Manager',
            page: Changephonenumber(),
          ),
          _buildDeleteAccountItem(context), // استبدال العنصر السابق
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context,
      {required IconData icon, required String title, required Widget page}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountItem(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: Icon(Icons.delete, color: Colors.black),
        title: Text('Delete Account', style: TextStyle(color: Colors.black)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () {
          _showDeleteConfirmationDialog(context);
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0C0C0C),
              fontSize: 24,
              fontFamily: 'Inria Serif',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account?',
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 27),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                      'Yes, Delete it',
                      style: TextStyle(
                        color: Color(0xFF0C0C0C),
                        fontSize: 18,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ),
                  style: ButtonStyle(),
                  onPressed: () {
                    // Add delete account logic here
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
