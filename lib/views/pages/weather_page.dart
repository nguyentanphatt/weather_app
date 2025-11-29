import 'package:flutter/material.dart';


class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key,
    required this.background,
    this.animation,
    required this.content,
  });

  final Widget background;
  final Widget? animation;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          background,
          if (animation != null) animation!,
          content,
        ],
      ),
    );
  }
}