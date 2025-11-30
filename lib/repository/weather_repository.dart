import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/views/models/weather_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRepository {
  final String _baseUrl = dotenv.env['BASEURL']!;
  final String apiKey = dotenv.env['APIKEY']!;

  Future<Position> getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, cannot request.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return WeatherModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}
