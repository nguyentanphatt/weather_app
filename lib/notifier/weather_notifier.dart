import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/views/models/weather_models.dart';

final weatherNotifierProvider =
    StateNotifierProvider<WeatherNotifier, AsyncValue<WeatherModel>>((ref) {
      return WeatherNotifier(WeatherRepository());
    });

class WeatherNotifier extends StateNotifier<AsyncValue<WeatherModel>> {
  final WeatherRepository repository;

  WeatherNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> loadWeather() async {
    try {
      state = const AsyncValue.loading();

      final position = await repository.getCurrentLocation();
      final weather = await repository.fetchWeather(
        position.latitude,
        position.longitude,
      );

      state = AsyncValue.data(weather);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
