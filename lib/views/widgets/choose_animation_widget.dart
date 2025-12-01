import 'package:flutter/material.dart';
import 'package:weather_app/views/animations/cloud_animation.dart';
import 'package:weather_app/views/animations/fog_animation.dart';
import 'package:weather_app/views/animations/rain_animation.dart';
import 'package:weather_app/views/animations/snow_animation.dart';
import 'package:weather_app/views/animations/star_animation.dart';
import 'package:weather_app/views/animations/thunder_animation.dart';
import 'package:weather_app/views/animations/water_droplet_animation.dart';
import 'package:weather_app/views/models/weather_models.dart';

List<Widget> chooseAnimationWidgets(WeatherModel data, DateTime currentTime) {
  final List<Widget> widgets = [];

  if (currentTime.hour >= 18) {
    widgets.add(StarBlinkingAnimation());
  }

  switch (data.main.toLowerCase()) {
    case 'rain':
      widgets.add(RainAnimation());
      break;
    case 'snow':
      widgets.add(SnowAnimation());
      break;
    case 'thunderstorm':
      widgets.add(RainAnimation(rainDropCount: 150,));
      widgets.add(ThunderStormAnimation());
      break;
    case 'fog':
      widgets.add(FogAnimation());
      break;
    case 'mist':
      widgets.add(FogAnimation());
      break;
    case 'drizzle':
      widgets.add(RainAnimation(rainDropCount: 30,));
      widgets.add(WaterDropletAnimation(dropletCount: 5));
      break;
    case 'clear':
      break;
    default:
      break;
  }

  if (data.main.toLowerCase() == 'clouds' || data.clouds > 40) {
    int cloudCount = 5; 
    if (data.clouds > 50) {
      cloudCount = 7;
    } else if (data.clouds > 80) {
      cloudCount = 10;
    }
    widgets.add(CloudAnimation(cloudCount: cloudCount));
  }

  return widgets;
}
