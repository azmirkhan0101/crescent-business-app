import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get fullHeight => MediaQuery.sizeOf(this).height;
  double get fullWidth => MediaQuery.sizeOf(this).width;

  bool get isMobileDevice => fullWidth < 600;
  bool get isTab => fullWidth >= 600;
}
