import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

// نموذج السؤال
class VideoQuestion {
  final String videoUrl;
  final List<String> choices;
  final int correctIndex;

  VideoQuestion({
    required this.videoUrl,
    required this.choices,
    required this.correctIndex,
  });
}

// الأسئلة
final List<VideoQuestion> questions = [
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=download&id=11OMA3HvVUv1bYAFNy631KR1g6quoKyBw',
    choices: [
      'That is funny',
      'Time is up',
      'We have great food',
      'Open the door'
    ],
    correctIndex: 2,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=download&id=1T59BhVbpdO1RByjn0iwXmKcB3sRKsHwH',
    choices: [
      'For the next stage',
      'She is happy',
      'This is fun',
      'He is tall'
    ],
    correctIndex: 0,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=download&id=1-BSn7z53Hjnd_VrnnRVYmZoK-xJqBQKs',
    choices: [
      'My cat loves to sleep',
      'Trying to maintain the resale point of view',
      'They have two cars',
      'I like your shoes'
    ],
    correctIndex: 1,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=download&id=13EGvkOop44iqAmZf0W9UZTmDCgzMVtLk',
    choices: [
      'He can jump very high',
      'We went to the zoo',
      'He is a kind boy',
      'I did not change my mind'
    ],
    correctIndex: 3,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=download&id=1TXsIsJxy79M4zTmxinXhhUWlz2g-1P3_',
    choices: [
      "That's my main job",
      'I see a bird on the tree',
      'I lost my pencil',
      'We live in a big house'
    ],
    correctIndex: 0,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=view&id=1EGMbqVoOkQYGDL1B76pEy7_v3JMn8ovt',
    choices: [
      'She is reading a book',
      'The baby is sleeping',
      'They came to my flat and broke a window',
      'She sings very well'
    ],
    correctIndex: 2,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=view&id=1wDRgeU-anu2sIKJmDZT8hHgwg2q_I2ap',
    choices: [
      'I have a red ball',
      'You must understand that',
      'The sun is bright',
      'It is cold outside'
    ],
    correctIndex: 1,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=view&id=1E6PfqqysdRmr7U6EaA56cZ2OOIfSe4M4',
    choices: [
      'It is time to go',
      'The cake tastes good',
      'He opened the door',
      "When they're discharged home"
    ],
    correctIndex: 3,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=view&id=1OTsNae4HKfWSiPZExOoW6wtRr2uUjydR',
    choices: [
      'We reach the end of the decade',
      'The water is hot',
      'She helps her mom',
      'I like your shoes'
    ],
    correctIndex: 0,
  ),
  VideoQuestion(
    videoUrl:
        'https://drive.google.com/uc?export=view&id=1345feiwNWrH2y0PB0_dUY78AJFb56cwp',
    choices: [
      'It is cold outside',
      'Then the eyes would see and they would know',
      'I see a bird on the tree',
      'I lost my pencil'
    ],
    correctIndex: 1,
  ),
];

class ChallengeScreen extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late List<VideoPlayerController> _controllers;
  bool _loading = true;
  int _current = 0;
  int _score = 0;
  int? _selected;

  // تخزين الأسئلة العشوائية
  late List<VideoQuestion> randomQuestions;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    // اختر 5 أسئلة عشوائية
    randomQuestions = List.from(questions)..shuffle();
    randomQuestions = randomQuestions.take(5).toList();

    _controllers = [];
    for (var q in randomQuestions) {
      final file = await DefaultCacheManager().getSingleFile(q.videoUrl);
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      _controllers.add(controller);
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_selected == null) return;
    final correct = randomQuestions[_current].correctIndex;
    final isRight = _selected == correct;
    if (isRight) _score++;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isRight ? 'Correct!' : 'Wrong!',
          style: TextStyle(color: isRight ? Colors.green : Colors.red),
        ),
        backgroundColor: Colors.black87,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Future.delayed(Duration(seconds: 1), () {
      if (_current < randomQuestions.length - 1) {
        setState(() {
          _current++;
          _selected = null;
        });
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Center(
              child: Text(
                'Finish',
                style: TextStyle(
                  color: Color(0xFF0A4627),
                  fontSize: 40,
                  fontFamily: 'Inria Serif',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min, // لضبط حجم المحتوى بشكل مناسب
              children: [
                Text(
                  'Your score: $_score / ${randomQuestions.length}',
                  textAlign: TextAlign.center, // توسيط النص
                  style: TextStyle(
                    color: Color(0xFF0C0C0C),
                    fontSize: 15,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w900,
                    //height: 1.50,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (r) => r.isFirst),
                    child: Text(
                      'Done',
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
                ), // إضافة مسافة بين النص والزر
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    final controller = _controllers[_current];
    final q = randomQuestions[_current];
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [Icon(Icons.menu, size: 30, color: Color(0xFF0A4627))]),
      //title: Text('Question ${_current + 1}/${randomQuestions.length}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () => controller.play()),
                  IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () => controller.pause()),
                  IconButton(
                      icon: Icon(Icons.replay),
                      onPressed: () {
                        controller.seekTo(Duration.zero);
                        controller.play();
                      }),
                ],
              ),
              SizedBox(height: 5),
              Text(
                "Which syntax fits this video ?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 15),
              ...List.generate(
                  q.choices.length,
                  (i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: RadioListTile<int>(
                          dense: true,
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            q.choices[i],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          value: i,
                          groupValue: _selected,
                          onChanged: (val) => setState(() => _selected = val),
                        ),
                      )),
              SizedBox(height: 16),
              Container(
                child: TextButton(
                  onPressed: _selected != null ? _confirm : null,
                  child: Text(
                    'Next',
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
      ),
    );
  }
}
