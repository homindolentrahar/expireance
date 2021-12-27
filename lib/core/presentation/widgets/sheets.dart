import 'package:flutter/material.dart';

class SheetIndicator extends StatelessWidget {
  const SheetIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
