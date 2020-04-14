import 'package:flutter/material.dart';

class ColumnMarginWidget extends StatelessWidget {
  final double x;
  const ColumnMarginWidget(this.x);
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x);
  }
}