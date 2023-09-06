import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundScrollView extends StatelessWidget
    implements PreferredSizeWidget {
  const BackgroundScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    int randomNumber = Random().nextInt(8) + 1;
    String randomBckg = 'images/$randomNumber.png';
    return Container(
      color: const Color(0xff2a2a2a),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          randomBckg,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
