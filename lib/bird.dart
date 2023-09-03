import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird({
    super.key,
    required this.birdY,
    required this.birdHeight,
    required this.birdWidth,
  });
  final birdY;
  final double birdWidth;
  final double birdHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, birdY),
      child: Image.asset(
        'assets/images/bird.png',
        width: MediaQuery.sizeOf(context).height * birdWidth / 2,
        height: MediaQuery.sizeOf(context).height * 3 / 4 * birdHeight / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
