import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/views/widgets/glass_card_widget.dart';

class TopContentWidget extends StatelessWidget {
  const TopContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Gò Vấp, HCM ",
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
            ),
            Text(
              "12:00 PM",
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "40",
              style: GoogleFonts.montserrat(
                fontSize: 96,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              "°",
              style: GoogleFonts.montserrat(
                fontSize: 96,
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
              Text("Quang", style: GoogleFonts.montserrat(color: Colors.white)),
              SizedBox(
                height: 20,
                child: VerticalDivider(thickness: 1, color: Colors.white),
              ),
              Row(
                children: [
                  Icon(Icons.thermostat, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "12°C",
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
                    "20°C",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
