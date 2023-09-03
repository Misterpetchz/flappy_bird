import 'dart:async';

import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bird variables
  static double birdY = 0;
  double initialPos = birdY;
  double time = 0;
  double height = 0;
  double gravity = -4.9;
  double velocity = 2.5; // jump strength
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  // game settings
  bool gameHasStarted = false;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  // score
  int score = 0;
  int highScore = 0;
  List<bool> barrierPassed = [false, false];

  void startGame() {
    gameHasStarted = true;
    loadHighScore();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }

      moveMap();

      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -birdWidth) {
        if (!barrierPassed[i]) {
          score++;
          barrierPassed[i] = true;
        }
      }

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
        barrierPassed[i] = false;
      }
    }
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    // check hitting top or bottom of screen
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      score = 0;
      barrierPassed = [false, false];
    });
  }

  Future<void> saveHighScore() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt('highScore', highScore);
  }

  Future<void> loadHighScore() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      highScore = pref.getInt('highScore') ?? 0;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Center(
            child: Text(
              'G A M E  O V E R',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            'Your Score : $score !',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          actions: [
            Center(
              child: GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );

    if (score > highScore) {
      highScore = score;
      saveHighScore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdHeight,
                        birdHeight: birdHeight,
                      ),
                      // top barrier
                      MyBarrier(
                        barrierHeight: barrierHeight[0][0],
                        barrierWidth: barrierWidth,
                        isThisBottomBarrier: false,
                        barrierX: barrierX[0],
                      ),
                      // bottom barrier
                      MyBarrier(
                        barrierHeight: barrierHeight[0][1],
                        barrierWidth: barrierWidth,
                        isThisBottomBarrier: true,
                        barrierX: barrierX[0],
                      ),
                      MyBarrier(
                        barrierHeight: barrierHeight[1][0],
                        barrierWidth: barrierWidth,
                        isThisBottomBarrier: false,
                        barrierX: barrierX[1],
                      ),
                      MyBarrier(
                        barrierHeight: barrierHeight[1][1],
                        barrierWidth: barrierWidth,
                        isThisBottomBarrier: true,
                        barrierX: barrierX[1],
                      ),
                      Container(
                        alignment: const Alignment(0, -0.5),
                        child: Text(
                          gameHasStarted ? '' : 'T A P  T O  P L A Y',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gameHasStarted
                          ? 'Score : $score'
                          : 'High Score : $highScore',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
