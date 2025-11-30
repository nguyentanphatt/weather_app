import 'package:flutter/material.dart';


class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key,
    required this.background,
    this.animations = const [],
    required this.content,
  });

  final Widget background;
  final List<Widget> animations;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          background,
          ...animations,
          content,
        ],
      ),
    );
  }
}