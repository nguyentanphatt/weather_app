import 'package:flutter/material.dart';
import 'package:weather_app/views/backgrounds/background.dart';

Widget chooseBackgroundWidget(DateTime currentTime) {
  final hour = currentTime.hour;
  if (hour >= 5 && hour < 6) {
    return Background(
      firstColor: Color(0xFFFF8E72),
      secondColor: Color(0xFFFFB6A1),
      thirdColor: Color(0xFFFFDFAF),
    );
  } else if (hour >= 6 && hour < 17) {
    return Background(
      firstColor: Color(0xFF1E81FF),
      secondColor: Color(0xFF57B2FF),
      thirdColor: Color(0xFFA7D8FF),
    );
  } else if (hour >= 17 && hour < 18) {
    return Background(
      firstColor: Color(0xFFA897C0),
      secondColor: Color(0xFFFF6B6B),
      thirdColor: Color(0xFFFF9E5E),
    );
  } else {
    return Background(
      firstColor: Color(0xFF000814),
      secondColor: Color(0xFF002855),
      thirdColor: Color(0xFF01498E),
    );
  }
}
