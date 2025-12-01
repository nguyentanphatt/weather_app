import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/views/models/location_models.dart';

class LocationRepository {

  final String email = dotenv.env['EMAIL']!;

  Future<List<LocationModel>> searchLocation(String query) async {
    if (query.isEmpty) return [];

    final encodedQuery = Uri.encodeComponent(query);
    final url =
        "https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=5&countrycodes=vn";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "FlutterApp ($email)",
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((item) => LocationModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch Nominatim API");
    }
  }
}
