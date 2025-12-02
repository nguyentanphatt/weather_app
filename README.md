# Weather App

A Flutter weather app that shows the current weather for the device location and for saved locations. It uses OpenWeatherMap for weather data and OpenStreetMap (Nominatim) for searching locations.


---

## Features

- Show current weather for the device's GPS location
- Search and save favorite locations (Nominatim search)
- Save and list multiple saved locations using SharedPreferences
- Beautiful animated backgrounds and weather icons (OpenWeatherMap icons)

## Data sources

- Weather data: OpenWeatherMap (https://openweathermap.org/). The app expects a base URL and an API key provided through environment variables.
- Place search / geocoding: Nominatim (OpenStreetMap) — the app calls the public Nominatim search endpoint and sends an email address in the User-Agent header (required by Nominatim usage policy).

---

## Project structure (important files)

- `lib/main.dart` — app entry point and dotenv loading
- `lib/repository/weather_repository.dart` — handles fetching weather data (expects BASEURL & APIKEY in .env)
- `lib/repository/location_repository.dart` — uses Nominatim search to find locations (sends EMAIL in headers)
- `lib/views/widget_tree.dart` — core UI and page controller, also responsible for pull-to-refresh and saved locations
- `lib/notifier/weather_notifier.dart` — riverpod notifier that drives weather fetching logic

---

## Environment variables / .env

Create a `.env` file at the project root (same directory as `pubspec.yaml`). `.env` is ignored by git by default.

Example `.env`:

- `BASEURL`: the base weather API endpoint. Example for OpenWeatherMap: `https://api.openweathermap.org/data/2.5/weather`.
- `APIKEY`: your OpenWeatherMap API key.
- `EMAIL`: an email address used as a user-agent header when requesting the Nominatim API (OpenStreetMap) — recommended by their usage policy to identify yourself.

Note: The app loads dotenv in `lib/main.dart`. If any of these variables are missing the app may throw an error at startup.

---

## Permissions

On Android and iOS the app needs location permissions to query the current device position. The repository already includes permission requests via the `geolocator` package.

Make sure you allow location services and grant the app permission when prompted.

---

## Run the app

1. Install Flutter and Android SDK / Xcode for your platform. Make sure you have an emulator or device available.
2. Create `.env` and paste your keys (see example above).
3. Run package install:

```bash
flutter pub get
```

4. Start an emulator or plug in a device, then run the app:

```bash
flutter run -d emulator-5554
```

If you run into permission or startup issues, check the logs and ensure `.env` is present and valid.

---

## Testing

Basic widget tests are in `test/widget_test.dart`. Run tests with:

```bash
flutter test
```

---

## Troubleshooting / common errors

- If you see a `ProcessException` like "Process exited abnormally with exit code 255" when running on Android emulator, first ensure your emulator is running and visible to `adb`:

```bash
adb devices
```

Then try launching the app again with `flutter run` or `flutter run -d <device-id>`.

- If the app crashes on startup, make sure your `.env` has `BASEURL` and `APIKEY` defined. `flutter_dotenv` is loaded in `main.dart`, and missing keys will cause errors where dotenv values are read.

---

## Notes and links

- OpenWeatherMap API docs: https://openweathermap.org/api
- Nominatim (OpenStreetMap) usage policy & search API: https://nominatim.org/release-docs/latest/api/Search/
