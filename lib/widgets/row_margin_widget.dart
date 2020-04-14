import 'package:flutter/material.dart';

class RowMarginWidget extends StatelessWidget {
  final double y;
  const RowMarginWidget(this.y);
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: y);
  }
}