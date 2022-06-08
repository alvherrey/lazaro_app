import 'dart:math';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned(
          top: -100,
          left: -30,
          child: _BlueBox(),
        ),
      ],
    );
  }
}

class _BlueBox extends StatelessWidget {
  const _BlueBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        width: 400,
        height: 500,
        decoration: BoxDecoration(
          // color: Colors.pink,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade200,
              Colors.grey.shade400
              // Color.fromRGBO(241, 142, 172, 1),
              // Color.fromRGBO(241, 142, 172, 1),
            ],
          ),
          borderRadius: BorderRadius.circular(80),
          // image: const DecorationImage(
          //   fit: BoxFit.cover,
          //   image: AssetImage('assets/scroll-1.png'),
          // ),
        ),
      ),
    );
  }
}
