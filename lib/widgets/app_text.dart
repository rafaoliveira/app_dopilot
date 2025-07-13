import 'package:flutter/material.dart';

@immutable
class AppText extends StatelessWidget {

  String text;

  AppText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }
}
