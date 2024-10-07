// Darshan Nair and Raahul Nair
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(SpookySurpriseApp());
}

class SpookySurpriseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Surprise',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> items = ['spook1', 'spook2', 'spook3', 'spook4'];
  String correctItem = 'spook4';

  @override
  void initState() {
    super.initState();
    playBackgroundMusic();
  }

  Future<void> playBackgroundMusic() async {
    await _audioPlayer.setAsset('audio/scary.mp3');
    await _audioPlayer.setLoopMode(LoopMode.one);
    await _audioPlayer.play();
  }

  Future<void> playJumpScare() async {
    await _audioPlayer.setAsset('audio/scary1.mp3');
    await _audioPlayer.play();
  }

  Future<void> playSuccessSound() async {
    await _audioPlayer.setAsset('audio/scary2.mp3');
    await _audioPlayer.play();
  }

  void checkItem(String item) {
    if (item == correctItem) {
      playSuccessSound();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You Found It!"),
            content: Text("Congratulations! You found the correct item!"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      playJumpScare();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Oh no! That was a trap!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tricky Halloween Game')),
      body: Stack(
        children: [
          // Background
          Image.asset('img/spook.jpg', fit: BoxFit.cover),
          // Add spooky characters/items
          ...items.map((item) {
            return Positioned(
              left: (50 + items.indexOf(item) * 70).toDouble(),
              top: (100 + (items.indexOf(item) % 2) * 70).toDouble(),
              child: GestureDetector(
                onTap: () => checkItem(item),
                child: AnimatedSpookyCharacter(item: item),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class AnimatedSpookyCharacter extends StatefulWidget {
  final String item;
  AnimatedSpookyCharacter({required this.item});

  @override
  _AnimatedSpookyCharacterState createState() =>
      _AnimatedSpookyCharacterState();
}

class _AnimatedSpookyCharacterState extends State<AnimatedSpookyCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(CurveTween(curve: Curves.easeInOut)),
      child: Image.asset(
        widget.item == 'spook4'
            ? 'img/spook1.avif'
            : widget.item == 'spook3'
                ? 'img/spook2.jpeg' // Trap image
                : 'img/spook3.jpeg', // Other item image
        width: 100,
        height: 100,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
