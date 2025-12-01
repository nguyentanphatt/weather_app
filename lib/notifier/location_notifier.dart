import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:weather_app/views/models/location_models.dart';

final locationRepositoryProvider = Provider((ref) => LocationRepository());

final locationSearchProvider =
    StateNotifierProvider<
      LocationSearchNotifier,
      AsyncValue<List<LocationModel>>
    >((ref) {
      return LocationSearchNotifier(ref.read(locationRepositoryProvider));
    });

class LocationSearchNotifier
    extends StateNotifier<AsyncValue<List<LocationModel>>> {
  final LocationRepository repository;

  LocationSearchNotifier(this.repository) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    try {
      if (query.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      state = const AsyncValue.loading();

      final results = await repository.searchLocation(query);

      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
