import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/views/animations/windchime.dart';
import 'package:weather_app/views/models/weather_models.dart';
import 'package:weather_app/views/widgets/glass_card_widget.dart';

final localTime = DateTime.now();
int hour = localTime.hour;
int minute = localTime.minute;

class TopContentWidget extends StatelessWidget {
  const TopContentWidget({super.key, required this.weather});
  final WeatherModel weather;
  String formatHour(int hour, int minute) {
    int displayHour = hour % 12;
    displayHour = displayHour == 0 ? 12 : displayHour;
    String period = hour >= 12 ? "PM" : "AM";
    String displayMinute = minute.toString().padLeft(2, '0');
    return "$displayHour:$displayMinute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "${weather.cityName}, ",
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
            ),
            Text(
              formatHour(hour, minute),
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              (weather.temp).toString(),
              style: GoogleFonts.montserrat(
                fontSize: 80,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              "°",
              style: GoogleFonts.montserrat(
                fontSize: 80,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        GlassCardWidget(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weather.main,
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
              SizedBox(
                height: 20,
                child: VerticalDivider(thickness: 1, color: Colors.white),
              ),
              Row(
                children: [
                  Icon(Icons.thermostat, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "${weather.temp}°C",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
                child: VerticalDivider(thickness: 1, color: Colors.white),
              ),
              Row(
                children: [
                  Icon(Icons.wb_sunny, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "${weather.feelsLike}°C",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        WindChime(
          windSpeed: weather.windSpeed,
          size: 50, 
        ),
      ],
    );
  }
}
