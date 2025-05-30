import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:login2/Challeneges/Main_Page.dart';
import 'package:login2/Challeneges/Test_Page.dart';
import 'package:video_player/video_player.dart';

class VideoLessonsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: VideoLessonsScreen(),
    );
  }
}

class VideoLessonsScreen extends StatefulWidget {
  @override
  _VideoLessonsScreenState createState() => _VideoLessonsScreenState();
}

class _VideoLessonsScreenState extends State<VideoLessonsScreen> {
  final List<String> videoUrls = [
    'https://drive.google.com/uc?export=download&id=14kdsAjaEwK_x30L7xkvC3kaP5YOSbCIs',
    'https://drive.google.com/uc?export=download&id=14UwanJRuI4Octf03GO2KY-kaMBRMDR0p',
    'https://drive.google.com/uc?export=download&id=1_1yFho6_Apc4MGGBZjfFTRdgT6iFy6wX',
    'https://drive.google.com/uc?export=download&id=1wYegIUwmHy_LNxxwdFd17zrSgID2MiHF',
    'https://drive.google.com/uc?export=download&id=1I3_wlkw_W_3jmkoSkDe7o_ITjn-ln0z6',
  ];

  int currentIndex = 0;
  VideoPlayerController? _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndInitializeVideo(currentIndex);
  }

  Future<void> _loadAndInitializeVideo(int index) async {
    setState(() {
      isLoading = true;
    });

    final file = await DefaultCacheManager().getSingleFile(videoUrls[index]);
    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
        });
        _controller!.play();
      });
  }

  void _changeLesson(int newIndex) async {
    if (newIndex >= videoUrls.length) {
      _showCompletionDialog();
      return;
    }

    _controller?.pause();
    _controller?.dispose();
    setState(() {
      currentIndex = newIndex;
      isLoading = true;
    });
    await _loadAndInitializeVideo(newIndex);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "Let's go",
            style: TextStyle(
              color: Color(0xFF0A4627),
              fontSize: 40,
              fontFamily: 'Inria Serif',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
        content: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Would you like to go to test yourself ?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 17),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF24744B), width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    'No, later',
                    style: TextStyle(fontSize: 16, fontFamily: 'Inria Serif'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChallengeScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
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
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 20,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildPlayPauseButton() {
    if (_controller == null || !_controller!.value.isInitialized)
      return SizedBox();

    return Column(
      children: [
        VideoProgressIndicator(
          _controller!,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Colors.green,
            bufferedColor: Colors.grey,
            backgroundColor: Colors.black12,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(height: 8),
        IconButton(
          iconSize: 50,
          icon: CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF0A4627),
            child: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
          ),
          onPressed: () {
            setState(() {
              _controller!.value.isPlaying
                  ? _controller!.pause()
                  : _controller!.play();
            });
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed:
              currentIndex > 0 ? () => _changeLesson(currentIndex - 1) : null,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 22),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF24744B), width: 1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Text(
              'Back',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inria Serif'),
            ),
          ),
        ),
        TextButton(
          onPressed: () => _changeLesson(currentIndex + 1),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
            child: Text(
              'Next',
              style: TextStyle(
                  color: Color(0xFFFEFEFE),
                  fontSize: 22,
                  fontFamily: 'Inria Serif'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomePage()));
            },
            icon: Icon(Icons.arrow_back)),
        actions: [Icon(Icons.menu, size: 30, color: Color(0xFF0A4627))],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Lesson ${currentIndex + 1} / ${videoUrls.length}',
              style: TextStyle(
                color: Color(0xFF0A4627),
                fontSize: 28,
                fontFamily: 'Inria Serif',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 12),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          SizedBox(height: 10),
          _buildPlayPauseButton(),
          Spacer(),
          _buildNavigationButtons(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
