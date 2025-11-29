import 'package:flutter/material.dart';
import 'package:weather_app/views/animations/star_animation.dart';

Widget chooseAnimationWidget(String main) {
  switch (main) {
    case "Clear":
      return StarBlinkingAnimation();
    default:
      return StarBlinkingAnimation(); 
  }
}
