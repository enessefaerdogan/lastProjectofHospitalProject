import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
extension MediaQueryExtension on BuildContext {
  double get getHeight => mediaQuery.size.height;
  double get getWidth  => mediaQuery.size.width;
  double height(double value) => mediaQuery.size.height*value;
  double width(double value) => mediaQuery.size.width*value;
}
