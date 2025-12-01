import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/notifier/weather_notifier.dart';
import 'package:weather_app/views/models/location_models.dart';
import 'package:weather_app/views/pages/weather_page.dart';
import 'package:weather_app/views/widgets/choose_animation_widget.dart';
import 'package:weather_app/views/widgets/choose_background_widget.dart';
import 'package:weather_app/views/widgets/top_content_widget.dart';

class LocationWeatherDetailPage extends ConsumerStatefulWidget {
  final LocationModel location;
  const LocationWeatherDetailPage({super.key, required this.location});

  @override
  ConsumerState<LocationWeatherDetailPage> createState() =>
      _LocationWeatherDetailPageState();
}

class _LocationWeatherDetailPageState
    extends ConsumerState<LocationWeatherDetailPage> {
  final localTime = DateTime.now();
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(weatherNotifierProvider.notifier)
          .loadWeatherByLatAndLng(widget.location.lat, widget.location.lng);
      _checkIfSaved();
    });
  }

  static bool _coordsEqual(double a, double b, [double tol = 1e-6]) => (a - b).abs() <= tol;

  Future<void> _checkIfSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_locations') ?? <String>[];

    for (final s in saved) {
      try {
        final map = jsonDecode(s) as Map<String, dynamic>;
        final latVal = map['lat'];
        final lngVal = map['lng'] ?? map['lon'];

        final lat = (latVal is num) ? latVal.toDouble() : double.tryParse('$latVal');
        final lng = (lngVal is num) ? lngVal.toDouble() : double.tryParse('$lngVal');

        if (lat != null && lng != null) {
          if (_coordsEqual(lat, widget.location.lat) && _coordsEqual(lng, widget.location.lng)) {
            if (!mounted) return;
            setState(() => _isSaved = true);
            return;
          }
        }
      } catch (_) {
      }
    }
    if (!mounted) return;
    setState(() => _isSaved = false);
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherNotifierProvider);
    return Scaffold(
      body: weatherAsync.when(
        data: (weather) => WeatherPage(
          background: chooseBackgroundWidget(localTime),
          animations: chooseAnimationWidgets(weather, localTime),
          content: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 60.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopContentWidget(weather: weather, disable: true, city:widget.location.name,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      spacing: 5,
                      children: [
                        IconButton(
                          onPressed: _isSaved
                              ? () {
                                  if (context.mounted) Navigator.pop(context, true);
                                }
                              : () async {
                            final prefs = await SharedPreferences.getInstance();
                            final saved = prefs.getStringList('saved_locations') ?? <String>[];
                            final itemJson = jsonEncode(widget.location.toJson());
                            final already = saved.any((s) {
                              try {
                                final map = jsonDecode(s) as Map<String, dynamic>;
                                final latVal = map['lat'];
                                final lngVal = map['lng'] ?? map['lon'];

                                final lat = (latVal is num) ? latVal.toDouble() : double.tryParse('$latVal');
                                final lng = (lngVal is num) ? lngVal.toDouble() : double.tryParse('$lngVal');

                                return lat != null && lng != null &&
                                    _coordsEqual(lat, widget.location.lat) &&
                                    _coordsEqual(lng, widget.location.lng);
                              } catch (_) {
                                return false;
                              }
                            });

                            if (!already) {
                              saved.add(itemJson);
                              await prefs.setStringList('saved_locations', saved);
                            }
                            if (mounted) setState(() => _isSaved = true);
                            if (context.mounted) Navigator.pop(context, true);
                          },
                            icon: Icon(_isSaved ? Icons.home : Icons.add,
                              color: Colors.black, size: 36),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            shadowColor: Colors.black.withValues( alpha: 
                              0.2,
                            ),
                            elevation: 4,
                          ),
                        ),
                        Text(_isSaved ? "Added" : "Add to start page", 
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
