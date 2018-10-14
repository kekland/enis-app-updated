import 'dart:math';

import 'package:flutter/material.dart';

var deg2rad = 0.0174533;

class WaveClipper extends CustomClipper<Path> {
  final double animationValue;

  WaveClipper(this.animationValue);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    List<Offset> sineWaveOffsets = new List();

    Random random = new Random.secure();

    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      double x = i.toDouble();
      double sineValue = sin((animationValue * 2 * 360 - i) % 360 * deg2rad);
      double amplitude = (1 - animationValue) * 20.0;
      sineWaveOffsets.add(new Offset(x, sineValue * amplitude + 20 * (1 - animationValue)));
    }

    path.addPolygon(sineWaveOffsets, false);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => animationValue != oldClipper.animationValue;
}
