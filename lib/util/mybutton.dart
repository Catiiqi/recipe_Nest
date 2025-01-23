import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final void Function()? onPressed;
  const Mybutton(
      {super.key,
      required this.onPressed,
      required this.child,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 70,
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(15)),
          child: child,
        ));
  }
}

//  height: 80,
// width: 300,
class Mytext extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;

  const Mytext(
      {super.key, required this.text, required this.color, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color, fontWeight: FontWeight.bold, fontSize: fontSize),
      textAlign: TextAlign.center,
    );
  }
}
