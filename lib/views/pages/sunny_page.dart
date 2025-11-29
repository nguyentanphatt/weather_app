import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/views/backgrounds/background.dart';
import 'package:weather_app/views/widgets/content_widget.dart';

class SunnyPage extends StatelessWidget {
  const SunnyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(
            firstColor: Color(0xFFFF8E72),
            secondColor: Color(0xFFFFB6A1),
            thirdColor: Color(0xFFFFDFAF),
          ),
          //animation
          ContentWidget()
        ],
      ),
    );
  }
}
