import 'package:flutter/material.dart';

extension WidgetWithContainer on Widget {
  Widget withContainer({EdgeInsetsGeometry? padding, EdgeInsetsGeometry? margin}) {
    return Container(
      padding: padding,
      margin: margin,
      child: this,
    );
  }
}