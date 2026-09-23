import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const BanglaArcheryApp());

class BanglaArcheryApp extends StatelessWidget {
  const BanglaArcheryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'বাংলা অক্ষর তীরন্দাজ',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'NotoSansBengali',
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final letters = const ['অ','আ','ই','ঈ','উ','ঊ','ঋ','এ','ঐ','ও'];
  final rng = Random();

  late AnimationController arrowController;
  Timer? timer;

  String target = 'অ';
  String falling = 'অ';
  double y = 0;
  int score = 0;
  int lives = 3;
  int level = 1;
  bool playing = false;
  bool shooting = false;
  bool hit = false;
  int roundId = 0;

  @override
  void initState() {
    super.initState();
    arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) resolveShot();
      });
  }

  @override
  void dispose() {
    timer?.cancel();
    arrowController.dispose();
    super.dispose();
  }

  void startGame() {
    timer?.cancel();
    setState(() {
      score = 0;
      lives = 3;
      level = 1;
      playing = true;
      shooting = false;
      hit = false;
    });
    nextRound();
  }

  void nextRound() {
    if (!mounted || !playing) return;
    final targetIndex = rng.nextInt(letters.length);
    int fallIndex;
    // Most rounds are target letters, with occasional decoys.
    if (rng.nextDouble() < .65) {
      fallIndex = targetIndex;
    } else {
      fallIndex = rng.nextInt(letters.length);
      if (fallIndex == targetIndex) fallIndex = (fallIndex + 1) % letters.length;
    }

    setState(() {
      target = letters[targetIndex];
      falling = letters[fallIndex];
      y = 0;
      hit = false;
      shooting = false;
      roundId++;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!mounted || !playing || shooting || hit) return;
      final speed = 1.7 + level * .35;
      setState(() => y += speed);
      if (y >= 320) {
        timer?.cancel();
        loseLife();
      }
    });
  }

  void shoot() {
    if (!playing || shooting || hit) return;
    timer?.cancel();
    setState(() => shooting = true);
    arrowController.forward(from: 0);
  }

  void resolveShot() {
    if (!mounted || !playing) return;
    setState(() => shooting = false);
    if (falling == target) {
      setState(() {
        hit = true;
        score += 10 * level;
        level = 1 + score ~/ 50;
      });
      Future.delayed(const Duration(milliseconds: 350), nextRound);
    } else {
      loseLife();
    }
  }

  void loseLife() {
    if (!mounted) return;
    setState(() => lives--);
    if (lives <= 0) {
      playing = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('🎮 খেলা শেষ'),
          content: Text('স্কোর: $score\nলেভেল: $level'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                startGame();
              },
              child: const Text('আবার খেলুন'),
            ),
          ],
        ),
      );
    } else {
      Future.delayed(const Duration(milliseconds: 350), nextRound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('🏹 বাংলা অক্ষর তীরন্দাজ'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('⭐ $score', style: const TextStyle(fontSize: 19)),
                  Text('❤️ $lives', style: const TextStyle(fontSize: 19)),
                  Text('📈 লেভেল $level', style: const TextStyle(fontSize: 19)),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final centerX = (c.maxWidth - 88) / 2;
                  final bottom = c.maxHeight - 88;
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.indigo.shade50,
                                Colors.orange.shade50,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 20,
                        right: 20,
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const Text('লক্ষ্য অক্ষর',
                                    style: TextStyle(fontSize: 18)),
                                Text(target,
                                    style: const TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (playing)
                        Positioned(
                          top: 115 + y,
                          left: centerX,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            opacity: hit ? 0 : 1,
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 180),
                              scale: hit ? 1.7 : 1,
                              child: Container(
                                width: 88,
                                height: 88,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.deepPurple,
                                    width: 4,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  falling,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (shooting)
                        AnimatedBuilder(
                          animation: arrowController,
                          builder: (_, __) {
                            final t = Curves.easeIn.transform(
                              arrowController.value,
                            );
                            final arrowY = bottom - (bottom - (115 + y)) * t;
                            return Positioned(
                              top: arrowY,
                              left: c.maxWidth / 2 - 18,
                              child: const Text(
                                '➶',
                                style: TextStyle(fontSize: 48),
                              ),
                            );
                          },
                        ),
                      if (!playing)
                        Center(
                          child: FilledButton.icon(
                            onPressed: startGame,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text(
                              'খেলা শুরু করুন',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: FilledButton(
                            onPressed: playing ? shoot : null,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 38,
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              '🏹 তীর ছুঁড়ুন',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
