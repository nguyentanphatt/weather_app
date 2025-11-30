import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/notifier/weather_notifier.dart';
import 'package:weather_app/views/models/weather_models.dart';
import 'package:weather_app/views/pages/weather_page.dart';
import 'package:weather_app/views/widgets/choose_animation_widget.dart';
import 'package:weather_app/views/widgets/choose_background_widget.dart';
import 'package:weather_app/views/widgets/content_widget.dart';

final exampleData = 
  {
  "name": "Ho Chi Minh City",
  "weather": [
    {
      "main": "Drizzle",
      "description": "broken clouds"
    }
  ],
  "main": {
    "temp": 20.97,
    "feels_like": 20.41,
    "temp_min": 21.54,
    "temp_max": 20.01,
    "pressure": 999,
    "humidity": 88,
  },
  "wind": {
    "speed": 3.5,
    "deg": 200
  },
  "clouds": {
    "all": 75
  }
};

final data = WeatherModel.fromJson(exampleData);

class WidgetTree extends ConsumerStatefulWidget {
  const WidgetTree({super.key});

  @override
  ConsumerState<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends ConsumerState<WidgetTree> {
  final localTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    ref.read(weatherNotifierProvider.notifier).loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    //final weatherAsync = AsyncValue.data(data);
    final weatherAsync = ref.watch(weatherNotifierProvider);

    return Scaffold(
      body: weatherAsync.when(
        data: (weather) => WeatherPage(
          background: chooseBackgroundWidget(localTime),
          animations: chooseAnimationWidgets(weather, localTime),
          content: ContentWidget(weather: weather),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
