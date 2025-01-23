import 'package:flutter/material.dart';

class MySekelton extends StatelessWidget {
  const MySekelton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1)),
        height: 150,
        margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            Placeholder(
              color: Colors.grey,
              fallbackHeight: 100,
            ),
            Text(
              'Empty',
              style: TextStyle(color: Colors.black),
              maxLines: 4,
            ),
          ],
        ),
      );
  }
}