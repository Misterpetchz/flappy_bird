import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  const MyBarrier({
    super.key,
    required this.barrierHeight,
    required this.barrierWidth,
    required this.isThisBottomBarrier,
    required this.barrierX,
  });

  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isThisBottomBarrier;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
        (2 * barrierX + barrierWidth) / (2 - barrierWidth),
        isThisBottomBarrier ? 1 : -1,
      ),
      child: Container(
        color: Colors.green,
        width: MediaQuery.sizeOf(context).width * barrierWidth / 2,
        height: MediaQuery.sizeOf(context).height * 3 / 4 * barrierHeight / 2,
      ),
    );
  }
}
