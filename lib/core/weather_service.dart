import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

class WeatherService {

  Future<Map<String, dynamic>> getWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    final weatherUrl = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': [
          'temperature_2m',
          'relative_humidity_2m',
          'apparent_temperature',
          'weather_code',
          'surface_pressure',
          'wind_speed_10m',
        ].join(','),
        'hourly': [
          'temperature_2m',
          'weather_code',
        ].join(','),
        'daily': [
          'weather_code',
          'temperature_2m_max',
          'temperature_2m_min',
        ].join(','),
        'timezone': 'auto',
        'forecast_days': '7',
      },
    );

    final weatherResponse =
        await http.get(weatherUrl).timeout(
          const Duration(
            seconds: 15
          ),
        );

    if (weatherResponse.statusCode != 200) {
      throw Exception(
        'Unable to fetch weather for current location',
      );
    }

    final Map<String, dynamic> weatherData =
        jsonDecode(weatherResponse.body);

    String locationName = 'Current Location';
    String countryName = '';

    try {
      final reverseUrl = Uri.https(
        'nominatim.openstreetmap.org',
        '/reverse',
        {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'format': 'json',
          'zoom': '10',
          'addressdetails': '1',
        },
      );
  
      final reverseResponse = await http.get(
        reverseUrl,
        headers: {
          'User-Agent': 'WeatherApplication/1.0',
        },
      ).timeout(const Duration(seconds: 15));
  
      if (reverseResponse.statusCode == 200) {
        final Map<String, dynamic> reverseData =
            jsonDecode(reverseResponse.body);
  
        final address =
            reverseData['address'] as Map<String, dynamic>?;
  
        if (address != null) {
          locationName =
              address['city']?.toString() ??
              address['town']?.toString() ??
              address['village']?.toString() ??
              address['county']?.toString() ??
              'Current Location';
  
          countryName =
              address['country']?.toString() ?? '';
        }
      }
    } catch (_) {
      // Weather still works even if city lookup fails.
    }

    weatherData['location'] = {
      'name': locationName,
      'country': countryName,
      'latitude': latitude,
      'longitude': longitude,
    };

    return weatherData;
  }


  Future<Map<String, dynamic>> getWeather(String city) async {
    final cleanCity = city.trim();

    if (cleanCity.isEmpty) {
      throw Exception('Please enter a city');
    }

    // 1. Convert city name into latitude and longitude
    final geoUrl = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      {
        'name': cleanCity,
        'count': '1',
        'language': 'en',
        'format': 'json',
      },
    );

    final geoResponse = await http.get(geoUrl).timeout(const Duration(seconds: 15));

    if (geoResponse.statusCode != 200) {
      throw Exception('Unable to search city');
    }

    final Map<String, dynamic> geoData =
        jsonDecode(geoResponse.body);

    final results = geoData['results'] as List?;

    if (results == null || results.isEmpty) {
      throw Exception('City not found');
    }

    final Map<String, dynamic> location =
        Map<String, dynamic>.from(results.first);

    final latitude = location['latitude'];
    final longitude = location['longitude'];

    if (latitude == null || longitude == null) {
      throw Exception('Invalid city location');
    }

    // 2. Fetch full weather data
    final weatherUrl = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),

        'current': [
          'temperature_2m',
          'relative_humidity_2m',
          'apparent_temperature',
          'weather_code',
          'surface_pressure',
          'wind_speed_10m',
        ].join(','),

        'hourly': [
          'temperature_2m',
          'weather_code',
        ].join(','),

        'daily': [
          'weather_code',
          'temperature_2m_max',
          'temperature_2m_min',
        ].join(','),

        'timezone': 'auto',
        'forecast_days': '7',
      },
    );

    final weatherResponse = await http.get(weatherUrl).timeout(
      const Duration(seconds: 15),
    );

    if (weatherResponse.statusCode != 200) {
      throw Exception(
        'Weather API ${weatherResponse.statusCode}: '
        '${weatherResponse.body}',
      );
    }

    final Map<String, dynamic> weatherData =
        jsonDecode(weatherResponse.body);

    // 3. Attach city information to weather response
    weatherData['location'] = {
      'name': location['name'],
      'country': location['country'] ?? '',
      'admin1': location['admin1'] ?? '',
      'latitude': latitude,
      'longitude': longitude,
    };

    return weatherData;
  }
}