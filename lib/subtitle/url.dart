import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'url_process_page.dart';

class Url extends StatefulWidget {
  const Url({super.key});

  @override
  State<Url> createState() => _UrlState();
}

class _UrlState extends State<Url> {
  final TextEditingController _urlController = TextEditingController();
  String responseText = '';

  final List<Map<String, String>> _languages = [
    {'label': 'English', 'code': 'en-US'},
    {'label': 'Türkçe', 'code': 'tr'},
    {'label': 'Español', 'code': 'es'},
  ];

  String? _selectedLanguage;

  // تحويل رابط Google Drive إلى رابط مباشر للتحميل
  String convertDriveLink(String url) {
    final idRegex1 = RegExp(r'd/([a-zA-Z0-9_-]+)');
    final idRegex2 = RegExp(r'id=([a-zA-Z0-9_-]+)');

    String? fileId;

    if (url.contains('drive.google.com')) {
      final match1 = idRegex1.firstMatch(url);
      final match2 = idRegex2.firstMatch(url);

      if (match1 != null) {
        fileId = match1.group(1);
      } else if (match2 != null) {
        fileId = match2.group(1);
      }
    }

    if (fileId != null) {
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }

    return url;
  }

  Future<void> processUrl() async {
    final rawUrl = _urlController.text.trim();

    if (rawUrl.isEmpty || _selectedLanguage == null) {
      setState(() {
        responseText = 'يرجى إدخال رابط الفيديو واختيار اللغة.';
      });
      return;
    }

    final convertedUrl = convertDriveLink(rawUrl);

    try {
      final apiUrl =
          Uri.parse('https://1a21-104-196-228-95.ngrok-free.app/process-url');

      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'video_url': convertedUrl,
          'language': _selectedLanguage,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videoLink = data['download_link'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoResultPage(videoUrl: videoLink),
          ),
        );
      } else {
        setState(() {
          responseText = 'خطأ في المعالجة: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        responseText = 'فشل الاتصال: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Url Page')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Enter Google Drive URL of your video'),
              SizedBox(height: 10),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'أدخل رابط Google Drive',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                hint: Text('اختر اللغة'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                },
                items: _languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang['code'],
                    child: Text(lang['label']!),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: processUrl,
                child: Text('Process'),
              ),
              SizedBox(height: 20),
              Text(
                responseText,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
