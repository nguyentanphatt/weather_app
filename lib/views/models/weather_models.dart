class WeatherModel {
  final String cityName;
  final String main;
  final String description;
  final double temp;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int windDeg;

  WeatherModel({
    required this.cityName,
    required this.main,
    required this.description,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final mainData = json['main'];
    final wind = json['wind'];

    return WeatherModel(
      cityName: json['name'],
      main: weather['main'],
      description: weather['description'],
      temp: (mainData['temp'] as num).toDouble(),
      tempMin: (mainData['temp_min'] as num).toDouble(),
      tempMax: (mainData['temp_max'] as num).toDouble(),
      humidity: mainData['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      windDeg: wind['deg'] as int,
    );
  }
}
