class LocationModel {
  final String name;
  final String formatted;
  final double lat;
  final double lng;
  final dynamic osmId;
  final String? osmType;

  LocationModel({
    required this.name,
    required this.formatted,
    required this.lat,
    required this.lng,
    this.osmId,
    this.osmType,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json["name"] ?? "",
      formatted: json["display_name"] ?? "",
        lat: (json["lat"] is num)
          ? (json["lat"] as num).toDouble()
          : double.tryParse(json["lat"] ?? "0") ?? 0.0,
        lng: (json["lon"] is num)
          ? (json["lon"] as num).toDouble()
          : double.tryParse(json["lon"] ?? "0") ?? 0.0,
      osmId: json["osm_id"],
      osmType: json["osm_type"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'display_name': formatted,
      'lat': lat,
      'lng': lng,
      'lon': lng,
      'osm_id': osmId,
      'osm_type': osmType,
    };
  }
}
