import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final String text;
  DetailItem(this.text);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SelectableText(
          text,
          style: TextStyle(
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
