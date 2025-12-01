import 'package:flutter/material.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key,
    required this.background,
    this.animations = const [],
    required this.content,
  });

  final Widget background;
  final List<Widget> animations;
  final Widget content;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with AutomaticKeepAliveClientMixin<WeatherPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          widget.background,
          ...widget.animations,
          widget.content,
        ],
      ),
    );
  }
}