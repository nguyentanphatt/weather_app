import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationRepository {
  Future<List<Map<String, dynamic>>> searchLocation(String query) async {
    if (query.isEmpty) return [];

    final encodedQuery = Uri.encodeComponent(query);
    final url =
        "https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=5&countrycodes=vn";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "FlutterApp (kyakya972003@gmail.com)", // bắt buộc
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;

      return data.map((item) {
        return {
          "name": item["name"] ?? "",
          "formatted": item["display_name"] ?? "",
          "lat": double.tryParse(item["lat"] ?? "0") ?? 0,
          "lng": double.tryParse(item["lon"] ?? "0") ?? 0,
          "osm_id": item["osm_id"],
          "osm_type": item["osm_type"],
        };
      }).toList();
    } else {
      throw Exception("Failed to fetch Nominatim API");
    }
  }
}
