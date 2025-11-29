import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key, 
  required this.firstColor,
  required this.secondColor,
  required this.thirdColor,
  });

  final Color firstColor;
  final Color secondColor;
  final Color thirdColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [firstColor, secondColor, thirdColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
