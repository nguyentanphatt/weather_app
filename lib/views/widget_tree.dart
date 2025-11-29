import 'package:flutter/material.dart';
import 'package:weather_app/views/pages/weather_page.dart';
import 'package:weather_app/views/widgets/choose_background_widget.dart';
import 'package:weather_app/views/widgets/content_widget.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final localTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: SunnyPage()
      body: WeatherPage(
        background: chooseBackgroundWidget(localTime), 
        //animation: animation, 
        content: ContentWidget()
        ),
    );
  }
}