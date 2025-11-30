import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/views/models/weather_models.dart';
import 'package:weather_app/views/widgets/glass_card_widget.dart';

class BottomContentWidget extends StatelessWidget {
  const BottomContentWidget({super.key, required this.weather});
  final WeatherModel weather;
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> weatherCards = [
      {"title": "Temp", "value": "${weather.temp}°C", "icon": Icons.thermostat},
      {
        "title": "Feels like",
        "value": "${weather.feelsLike}°C",
        "icon": Icons.wb_sunny,
      },
      {
        "title": "Humidity",
        "value": "${weather.humidity}%",
        "icon": Icons.opacity,
      },
      {
        "title": "Pressure",
        "value": "${weather.pressure} hPa",
        "icon": Icons.speed,
      },
      {"title": "Wind", "value": "${weather.windSpeed} m/s", "icon": Icons.air},
      {"title": "Clouds", "value": "${weather.clouds}%", "icon": Icons.cloud},
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Column(
          children: List.generate(3, (rowIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children:
                    List.generate(2, (colIndex) {
                        int index = rowIndex * 2 + colIndex;
                        final card = weatherCards[index];

                        return Expanded(
                          child: GlassCardWidget(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      card["icon"],
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      card["title"],
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  card["value"],
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).expand((w) => [w, const SizedBox(width: 10)]).toList()
                      ..removeLast(),
              ),
            );
          }),
        ),
      ),
    );
  }
}
