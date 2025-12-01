class WeatherData {
  final WeatherModel weather;
  final String? cityName;
  final String? savedJson;
  WeatherData({required this.weather, this.cityName, this.savedJson});
}


class WeatherModel {
  final String cityName;
  final String main;
  final String description;
  final String icon;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final int clouds;

  WeatherModel({
    required this.cityName,
    required this.main,
    required this.description,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.clouds,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final mainData = json['main'];
    final wind = json['wind'];
    final cloud = json['clouds'];

    return WeatherModel(
      cityName: json['name'],
      main: weather['main'],
      description: weather['description'],
      icon: weather['icon'],
      temp: (mainData['temp'] as num).toDouble(),
      feelsLike: (mainData['feels_like'] as num).toDouble(),
      tempMin: (mainData['temp_min'] as num).toDouble(),
      tempMax: (mainData['temp_max'] as num).toDouble(),
      pressure: mainData['pressure'] as int,
      humidity: mainData['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      windDeg: wind['deg'] as int,
      clouds: cloud['all'] as int,
    );
  }
}
