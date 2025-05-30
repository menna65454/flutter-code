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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lipreading Trainer',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lipreading Trainer Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LearningScreen())),
              child: Text('Learning Videos'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ChallengeScreen())),
              child: Text('Start Challenge'),
            ),
          ],
        ),
      ),
    );
  }
}

// شاشة التعليم
class LearningScreen extends StatefulWidget {
  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late VideoPlayerController _c1, _c2;
  bool _watched1 = false, _watched2 = false;

  @override
  void initState() {
    super.initState();
    _initController(0).then((ctrl) => _c1 = ctrl);
    _initController(1).then((ctrl) => _c2 = ctrl);
  }

  Future<VideoPlayerController> _initController(int index) async {
    final file =
        await DefaultCacheManager().getSingleFile(questions[index].videoUrl);
    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    controller.addListener(() {
      if (controller.value.position >= controller.value.duration) {
        setState(() {
          if (index == 0) _watched1 = true;
          if (index == 1) _watched2 = true;
        });
      }
    });
    setState(() {});
    return controller;
  }

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _watched1 && _watched2;
    return Scaffold(
      appBar: AppBar(title: Text('Learning Videos')),
      body: Column(
        children: [
          if (_c1.value.isInitialized) ...[
            AspectRatio(
                aspectRatio: _c1.value.aspectRatio, child: VideoPlayer(_c1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.play_arrow), onPressed: () => _c1.play()),
                IconButton(
                    icon: Icon(Icons.pause), onPressed: () => _c1.pause()),
                IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      _c1.seekTo(Duration.zero);
                      _c1.play();
                    }),
              ],
            ),
          ],
          if (_c2.value.isInitialized) ...[
            AspectRatio(
                aspectRatio: _c2.value.aspectRatio, child: VideoPlayer(_c2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.play_arrow), onPressed: () => _c2.play()),
                IconButton(
                    icon: Icon(Icons.pause), onPressed: () => _c2.pause()),
                IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      _c2.seekTo(Duration.zero);
                      _c2.play();
                    }),
              ],
            ),
          ],
          Spacer(),
          ElevatedButton(
            onPressed: canContinue ? () => Navigator.pop(context) : null,
            child: Text('Back to Home'),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

// شاشة التحدي
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

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    _controllers = [];
    for (var q in questions) {
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
    final correct = questions[_current].correctIndex;
    final isRight = _selected == correct;
    if (isRight) _score++;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(isRight ? 'Correct!' : 'Wrong!'),
          duration: Duration(seconds: 1)),
    );
    Future.delayed(Duration(seconds: 1), () {
      if (_current < questions.length - 1) {
        setState(() {
          _current++;
          _selected = null;
        });
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Finished'),
            content: Text('Your score: $_score / ${questions.length}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: Text('Home'),
              )
            ],
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
    final q = questions[_current];
    return Scaffold(
      appBar:
          AppBar(title: Text('Question ${_current + 1}/${questions.length}')),
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
              SizedBox(height: 24),
              ...List.generate(
                  q.choices.length,
                  (i) => RadioListTile<int>(
                        title: Text(q.choices[i]),
                        value: i,
                        groupValue: _selected,
                        onChanged: (val) => setState(() => _selected = val),
                      )),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _selected != null ? _confirm : null,
                  child: Text('Confirm')),
            ],
          ),
        ),
      ),
    );
  }
}
// final List<VideoQuestion> questions = [
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=download&id=11OMA3HvVUv1bYAFNy631KR1g6quoKyBw',
//     choices: [
//       'That is funny',
//       'Time is up',
//       'We have great food',
//       'Open the door'
//     ],
//     correctIndex: 2,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=download&id=1T59BhVbpdO1RByjn0iwXmKcB3sRKsHwH',
//     choices: [
//       'For the next stage',
//       'She is happy',
//       'This is fun',
//       'He is tall'
//     ],
//     correctIndex: 0,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=download&id=1-BSn7z53Hjnd_VrnnRVYmZoK-xJqBQKs',
//     choices: [
//       'My cat loves to sleep',
//       'Trying to maintain the resale point of view',
//       'They have two cars',
//       'I like your shoes'
//     ],
//     correctIndex: 1,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=download&id=13EGvkOop44iqAmZf0W9UZTmDCgzMVtLk',
//     choices: [
//       'He can jump very high',
//       'We went to the zoo',
//       'He is a kind boy',
//       'I did not change my mind'
//     ],
//     correctIndex: 3,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=download&id=1TXsIsJxy79M4zTmxinXhhUWlz2g-1P3_',
//     choices: [
//       "That's my main job",
//       'I see a bird on the tree',
//       'I lost my pencil',
//       'We live in a big house'
//     ],
//     correctIndex: 0,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=view&id=1EGMbqVoOkQYGDL1B76pEy7_v3JMn8ovt',
//     choices: [
//       'She is reading a book',
//       'The baby is sleeping',
//       'They came to my flat and broke a window',
//       'She sings very well'
//     ],
//     correctIndex: 2,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=view&id=1wDRgeU-anu2sIKJmDZT8hHgwg2q_I2ap',
//     choices: [
//       'I have a red ball',
//       'You must understand that',
//       'The sun is bright',
//       'It is cold outside'
//     ],
//     correctIndex: 1,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=view&id=1E6PfqqysdRmr7U6EaA56cZ2OOIfSe4M4',
//     choices: [
//       'It is time to go',
//       'The cake tastes good',
//       'He opened the door',
//       "When they're discharged home"
//     ],
//     correctIndex: 3,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=view&id=1OTsNae4HKfWSiPZExOoW6wtRr2uUjydR',
//     choices: [
//       'We reach the end of the decade',
//       'The water is hot',
//       'She helps her mom',
//       'I like your shoes'
//     ],
//     correctIndex: 0,
//   ),
//   VideoQuestion(
//     videoUrl:
//         'https://drive.google.com/uc?export=view&id=1345feiwNWrH2y0PB0_dUY78AJFb56cwp',
//     choices: [
//       'It is cold outside',
//       'Then the eyes would see and they would know',
//       'I see a bird on the tree',
//       'I lost my pencil'
//     ],
//     correctIndex: 1,
//   ),
// ];
