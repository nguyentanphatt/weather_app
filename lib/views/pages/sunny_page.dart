import 'package:flutter/material.dart';
import 'package:weather_app/views/animations/star_animation.dart';
import 'package:weather_app/views/backgrounds/background.dart';

class SunnyPage extends StatelessWidget {
  const SunnyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(
            firstColor: Color(0xFFFF8E72),
            secondColor: Color(0xFFFFB6A1),
            thirdColor: Color(0xFFFFDFAF),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Text("Gò Vấp", style: TextStyle(),),
                  Row(
                    children: [
                      Text(
                        "40",
                        style: TextStyle(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "°",
                        style: TextStyle(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text("Quang"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
