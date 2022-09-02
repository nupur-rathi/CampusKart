// This is a custom button we used in various places
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {required this.colour, required this.title, required this.onPressed});
  final Color colour;
  final String title;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      textStyle: const TextStyle(fontSize: 17, color: Colors.white),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 800.0,
        height: 42.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
