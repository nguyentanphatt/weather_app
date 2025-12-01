import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/views/animations/windchime.dart';
import 'package:weather_app/views/models/weather_models.dart';
import 'package:weather_app/views/pages/search_page.dart';
import 'package:weather_app/views/widgets/glass_card_widget.dart';

class TopContentWidget extends StatelessWidget {
  const TopContentWidget({
    super.key,
    required this.weather,
    this.disable = false,
    this.city = "",
    this.onAdded,
    this.isSaved = false,
    this.savedJson,
    this.onDelete,
  });
  final WeatherModel weather;
  final bool disable;
  final String? city;
  final VoidCallback? onAdded;
  final bool isSaved;
  final String? savedJson;
  final ValueChanged<String>? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!disable || isSaved)
          ListTile(
            contentPadding: EdgeInsets.zero,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isSaved && !disable)
                  GestureDetector(
                    onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SearchPage();
                        },
                      ),
                    );

                    if (result == true) {
                      onAdded?.call();
                    }
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                    weight: 10,
                    grade: 200,
                    opticalSize: 48,
                  ),
                ),
                if (isSaved)
                  GestureDetector(
                    onTap: () {
                      if (savedJson != null) onDelete?.call(savedJson!);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Row(
          children: [
            Text(
              city == null || city!.isEmpty ? weather.cityName : city!,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
              Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                    width: 30,
                    height: 30,
                    color: Colors.white,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                  Text(
                    weather.main,
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
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
              const SizedBox(
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
        const SizedBox(height: 10),
        WindChime(windSpeed: weather.windSpeed, size: 50),
      ],
    );
  }
}
