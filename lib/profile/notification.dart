// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login2/profile/editprofile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final supabase = Supabase.instance.client;
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final response = await supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    setState(() {
      notifications = response;
      isLoading = false;
    });
  }

  Future<void> _markAsRead(String notificationId) async {
    await supabase
        .from('notifications')
        .update({'is_read': true}).eq('id', notificationId);
    await _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text(''))
              : RefreshIndicator(
                  onRefresh: _fetchNotifications,
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final title = notification['title'];
                      final body = notification['body'];
                      final isRead = notification['is_read'] ?? false;

                      // تحقق: هل هذا إشعار "أكمل ملفك الشخصي"؟
                      final isProfilePrompt = title == 'Welcome';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Icon(
                            isRead
                                ? Icons.notifications
                                : Icons.notifications_active,
                            color: isRead ? Colors.grey : Colors.green,
                          ),
                          title: Text(title),
                          subtitle: Text(body),
                          trailing: isProfilePrompt
                              ? IconButton(
                                  icon: Icon(Icons.edit, color: Colors.teal),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Personalinfo()),
                                    );
                                  },
                                )
                              : null,
                        ),
                      );
                    },
                  )),
    );
  }
}
