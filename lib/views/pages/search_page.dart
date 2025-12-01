import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/notifier/location_notifier.dart';
import 'package:weather_app/views/pages/location_weather_detail_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  Timer? _debounce;
  bool hasSearched = false;

  void _onSearchChanged(String query) {
    hasSearched = query.isNotEmpty;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(locationSearchProvider.notifier).search(query);
    });

    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(locationSearchProvider);
    final brightness = MediaQuery.of(context).platformBrightness;
    return Theme(
      data: brightness == Brightness.dark
          ? ThemeData.dark()
          : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search location",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Location (District 7,...)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: searchState.when(
                  data: (list) {
                    if (!hasSearched) {
                      return const Center(
                        child: Text("Type something to search..."),
                      );
                    }

                    if (list.isEmpty) {
                      return const Center(child: Text("Result not found"));
                    }

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final item = list[i];

                        return ListTile(
                          title: Text(item.formatted),
                          leading: const Icon(Icons.location_on),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LocationWeatherDetailPage(location: item),
                              ),
                            );

                            if (result == true) Navigator.pop(context, true);
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, st) => Center(child: Text("Error: $err")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
