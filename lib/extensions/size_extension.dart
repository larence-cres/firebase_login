import 'package:flutter/material.dart';

extension SizeExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  double heightPercent(double percent) {
    return (percent / 100) * height;
  }

  double widthPercent(double percent) {
    return (percent / 100) * width;
  }
}
