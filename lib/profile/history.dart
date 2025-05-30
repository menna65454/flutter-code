import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _videos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('video_history')
          .select()
          .eq('user_id', user.id)
          .order('timestamp', ascending: false);

      setState(() {
        _videos = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    }
  }

  Future<void> _deleteVideo(String videoUrl) async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('video_history')
          .delete()
          .eq('user_id', user.id)
          .eq('video_url', videoUrl);

      // تحديث الواجهة بعد الحذف
      setState(() {
        _videos.removeWhere((video) => video['video_url'] == videoUrl);
      });

      // إظهار رسالة تأكيد الحذف
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video deleted successfully.')),
      );
    }
  }

  void _playVideo(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('History Page'),
          backgroundColor: Colors.white,
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : _videos.isEmpty
                ? Center(child: Text('No saved videos yet.'))
                : ListView.builder(
                    itemCount: _videos.length,
                    itemBuilder: (context, index) {
                      final video = _videos[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Video ${index + 1}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              VideoPreview(
                                videoUrl: video['video_url'],
                                onPlay: () => _playVideo(video['video_url']),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _showDeleteConfirmationDialog(
                                            video['video_url']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ));
  }

  void _showDeleteConfirmationDialog(String videoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Delete Video'),
          content: Text('Are you sure you want to delete this video?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteVideo(videoUrl);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => _initialized = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video")),
      body: Center(
        child: _initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class VideoPreview extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onPlay;

  const VideoPreview({Key? key, required this.videoUrl, required this.onPlay})
      : super(key: key);

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(
      widget.videoUrl,
      quality: 75, // الجودة المطلوبة من 0 إلى 100
      position: -1, // الحصول على صورة من منتصف الفيديو
    );

    setState(() {
      _thumbnailBytes =
          thumbnailFile.readAsBytesSync(); // تحويل الملف إلى بيانات البايت
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black12,
            image: _thumbnailBytes != null
                ? DecorationImage(
                    image: MemoryImage(_thumbnailBytes!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _thumbnailBytes == null
              ? Center(child: CircularProgressIndicator())
              : null,
        ),
        Positioned.fill(
          child: Center(
            child: IconButton(
              icon:
                  Icon(Icons.play_circle_fill, size: 64, color: Colors.white70),
              onPressed: widget.onPlay,
            ),
          ),
        ),
      ],
    );
  }
}
