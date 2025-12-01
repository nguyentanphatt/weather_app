import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/notifier/weather_notifier.dart';
import 'dart:convert';
import 'package:weather_app/views/models/weather_models.dart';
import 'package:weather_app/views/widgets/content_widget.dart';
import 'package:weather_app/views/widgets/choose_animation_widget.dart';
import 'package:weather_app/views/widgets/choose_background_widget.dart';

class WidgetTree extends ConsumerStatefulWidget {
  const WidgetTree({super.key});

  @override
  ConsumerState<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends ConsumerState<WidgetTree> {
  final localTime = DateTime.now();
  List<WeatherData> weatherList = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? cityName = "";

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });

    ref.read(weatherNotifierProvider.notifier).loadWeather().then((weather) {
      setState(() {
        weatherList.add(
          WeatherData(weather: weather, cityName: null, savedJson: null),
        );
      });
      Future.microtask(() async {
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getStringList('saved_locations') ?? <String>[];
        if (saved.isNotEmpty) {
          for (final s in saved) {
            try {
              final Map<String, dynamic> map = jsonDecode(s);
              final name = map['name'] ?? map['display_name'] ?? '';
              final lat = (map['lat'] is String)
                  ? double.tryParse(map['lat']) ?? 0.0
                  : (map['lat'] as num?)?.toDouble() ?? 0.0;
              final lng = (map['lng'] is String)
                  ? double.tryParse(map['lng']) ?? 0.0
                  : (map['lng'] as num?)?.toDouble() ?? 0.0;

              final weatherPrefs = await ref
                  .read(weatherNotifierProvider.notifier)
                  .loadWeatherByLatAndLng(lat, lng);
              setState(() {
                weatherList.add(
                  WeatherData(
                    weather: weatherPrefs,
                    cityName: name,
                    savedJson: s,
                  ),
                );
              });
            } catch (_) {}
          }
          setState(() {
            cityName = (saved.isNotEmpty)
                ? (jsonDecode(saved.first)['name'] ?? '')
                : cityName;
          });
        }
      });
    });
  }

  Future<void> _reloadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_locations') ?? <String>[];

    if (!mounted) return;

    if (saved.isEmpty) {
      setState(() {
        if (weatherList.length > 1){
          weatherList.removeRange(1, weatherList.length);
        }
      });
      return;
    }

    final newSavedWeather = <WeatherData>[];

    for (final s in saved) {
      try {
        final Map<String, dynamic> map = jsonDecode(s);
        final name = map['name'] ?? map['display_name'] ?? '';
        final lat = (map['lat'] is String)
            ? double.tryParse(map['lat']) ?? 0.0
            : (map['lat'] as num?)?.toDouble() ?? 0.0;
        final lng = (map['lng'] is String)
            ? double.tryParse(map['lng']) ?? 0.0
            : (map['lng'] as num?)?.toDouble() ?? 0.0;

        final weatherPrefs = await ref
            .read(weatherNotifierProvider.notifier)
            .loadWeatherByLatAndLng(lat, lng);

        newSavedWeather.add(
          WeatherData(weather: weatherPrefs, cityName: name, savedJson: s),
        );
      } catch (_) {}
    }

    setState(() {
      final current = weatherList.isNotEmpty ? weatherList.first : null;
      weatherList = [];
      if (current != null) weatherList.add(current);
      weatherList.addAll(newSavedWeather);
    });

    if (_pageController.hasClients) {
      final lastIndex = weatherList.length - 1;
      if (lastIndex > 0) {
        _pageController.animateToPage(
          lastIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Future<void> _removeSavedItem(String savedJson) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_locations') ?? <String>[];
    final updated = saved.where((s) => s != savedJson).toList();
    await prefs.setStringList('saved_locations', updated);
    await _reloadSavedLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (weatherList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentData = weatherList[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          chooseBackgroundWidget(localTime),
          ...chooseAnimationWidgets(currentData.weather, localTime),
          ContentWidget(
            currentData: currentData,
            pageController: _pageController,
            currentPage: _currentPage,
            totalPages: weatherList.length,
            onAdded: _reloadSavedLocation,
            onDelete: _removeSavedItem,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
