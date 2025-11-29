import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/views/widgets/glass_card_widget.dart';

final List<Map<String, dynamic>> weatherCards = [
  {"title": "Temp", "value": "40°C", "icon": Icons.thermostat},
  {"title": "Feels like", "value": "38°C", "icon": Icons.wb_sunny},
  {"title": "Humidity", "value": "80%", "icon": Icons.opacity},
  {"title": "Pressure", "value": "1003 hPa", "icon": Icons.speed},
  {"title": "Wind", "value": "4.6 m/s", "icon": Icons.air},
  {"title": "Clouds", "value": "40%", "icon": Icons.cloud},
];

class BottomContentWidget extends StatelessWidget {
  const BottomContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children:
                List.generate(2, (colIndex) {
                    int index =
                        rowIndex * 2 + colIndex;
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
                  }).expand((widget) => [widget, SizedBox(width: 10)]).toList()
                  ..removeLast(),
          ),
        );
      }),
    );
  }
}
