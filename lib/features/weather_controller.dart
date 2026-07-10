import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../core/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService _weatherService = WeatherService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final cityName = 'New Delhi'.obs;
  final countryName = 'India'.obs;

  final temperature = 0.0.obs;
  final feelsLike = 0.0.obs;
  final humidity = 0.obs;
  final windSpeed = 0.0.obs;
  final pressure = 0.0.obs;
  final weatherCode = (-1).obs;

  final hourlyForecast = <Map<String, dynamic>>[].obs;
  final dailyForecast = <Map<String, dynamic>>[].obs;

  Future<void> fetchCurrentLocationWeather() async {
  try {
    isLoading.value = true;
    errorMessage.value = '';

    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        'Please enable location services',
      );
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        'Location permission denied',
      );
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied',
      );
    }

    final position =
        await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 20),
          ),
        );
    
    final data =
        await _weatherService.getWeatherByCoordinates(
      position.latitude,
      position.longitude,
    );

    _parseLocation(data);
    _parseCurrentWeather(data);
    _parseHourlyForecast(data);
    _parseDailyForecast(data);
  } catch (e) {
    errorMessage.value = _cleanErrorMessage(e);
  } finally {
    isLoading.value = false;
  }
}

  Future<void> fetchWeather(String city) async {
    final cleanCity = city.trim();

    if (cleanCity.isEmpty) {
      errorMessage.value = 'Please enter a city';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _weatherService.getWeather(
        cleanCity,
      );

      _parseLocation(data);
      _parseCurrentWeather(data);
      _parseHourlyForecast(data);
      _parseDailyForecast(data);
    } catch (e) {
      errorMessage.value = _cleanErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _parseLocation(Map<String, dynamic> data) {
    final location =
        data['location'] as Map<String, dynamic>?;

    if (location == null) {
      return;
    }

    cityName.value =
        location['name']?.toString() ?? '';

    countryName.value =
        location['country']?.toString() ?? '';
  }

  void _parseCurrentWeather(
    Map<String, dynamic> data,
  ) {
    final current =
        data['current'] as Map<String, dynamic>?;

    if (current == null) {
      return;
    }

    temperature.value = _toDouble(
      current['temperature_2m'],
    );

    feelsLike.value = _toDouble(
      current['apparent_temperature'],
    );

    humidity.value = _toInt(
      current['relative_humidity_2m'],
    );

    windSpeed.value = _toDouble(
      current['wind_speed_10m'],
    );

    pressure.value = _toDouble(
      current['surface_pressure'],
    );

    weatherCode.value = _toInt(
      current['weather_code'],
    );
  }

  void _parseHourlyForecast(
  Map<String, dynamic> data,
) {
  final hourly =
      data['hourly'] as Map<String, dynamic>?;

  if (hourly == null) {
    hourlyForecast.clear();
    return;
  }

  final times = hourly['time'] as List? ?? [];
  final temperatures =
      hourly['temperature_2m'] as List? ?? [];
  final codes =
      hourly['weather_code'] as List? ?? [];

  hourlyForecast.clear();

  final itemCount = [
    times.length,
    temperatures.length,
    codes.length,
  ].reduce(
    (a, b) => a < b ? a : b,
  );

  if (itemCount == 0) {
    return;
  }

  final now = DateTime.now();

  int startIndex = 0;

  for (int i = 0; i < itemCount; i++) {
    final forecastTime = DateTime.tryParse(
      times[i].toString(),
    );

    if (forecastTime == null) {
      continue;
    }

    if (!forecastTime.isBefore(now)) {
      startIndex = i;
      break;
    }
  }

  final endIndex = (startIndex + 24) < itemCount
      ? startIndex + 24
      : itemCount;

  for (int i = startIndex; i < endIndex; i++) {
    hourlyForecast.add({
      'time': _formatTime(
        times[i].toString(),
      ),
      'temperature': _toDouble(
        temperatures[i],
      ),
      'weatherCode': _toInt(
        codes[i],
      ),
    });
  }
}

  void _parseDailyForecast(
    Map<String, dynamic> data,
  ) {
    final daily =
        data['daily'] as Map<String, dynamic>?;

    if (daily == null) {
      dailyForecast.clear();
      return;
    }

    final dates = daily['time'] as List? ?? [];
    final maxTemperatures =
        daily['temperature_2m_max'] as List? ?? [];
    final minTemperatures =
        daily['temperature_2m_min'] as List? ?? [];
    final codes =
        daily['weather_code'] as List? ?? [];

    dailyForecast.clear();

    final itemCount = [
      dates.length,
      maxTemperatures.length,
      minTemperatures.length,
      codes.length,
    ].reduce(
      (a, b) => a < b ? a : b,
    );

    for (int i = 0; i < itemCount; i++) {
      dailyForecast.add({
        'date': dates[i].toString(),
        'maxTemperature': _toDouble(
          maxTemperatures[i],
        ),
        'minTemperature': _toDouble(
          minTemperatures[i],
        ),
        'weatherCode': _toInt(
          codes[i],
        ),
      });
    }
  }

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }

  int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  String _formatTime(String value) {
    final dateTime = DateTime.tryParse(value);

    if (dateTime == null) {
      return value;
    }

    final hour = dateTime.hour;

    if (hour == 0) {
      return '12 AM';
    }

    if (hour == 12) {
      return '12 PM';
    }

    if (hour > 12) {
      return '${hour - 12} PM';
    }

    return '$hour AM';
  }

  String _cleanErrorMessage(Object error) {

    final message =error.toString();

    if(
      message.contains('TimeoutException') ||
      message.contains('SocketException') ||
      message.contains('semaphore timeout')
    ){
      return 'Unable to connect to weather service. plese check your internet connection and try again';

    }
    return message.replaceFirst(
      'Exception: ',
      '',
    );
  }

  String get weatherCondition {
    return conditionFromCode(
      weatherCode.value,
    );
  }

  String conditionFromCode(int code) {
    if(code == -1){
      return 'Weather unavailable';
    }
    if (code == 0) {
      return 'Clear Sky';
    }

    if (code == 1) {
      return 'Mainly Clear';
    }

    if (code == 2) {
      return 'Partly Cloudy';
    }

    if (code == 3) {
      return 'Overcast';
    }

    if (code == 45 || code == 48) {
      return 'Foggy';
    }

    if (code >= 51 && code <= 57) {
      return 'Drizzle';
    }

    if (code >= 61 && code <= 67) {
      return 'Rainy';
    }

    if (code >= 71 && code <= 77) {
      return 'Snowy';
    }

    if (code >= 80 && code <= 82) {
      return 'Rain Showers';
    }

    if (code >= 85 && code <= 86) {
      return 'Snow Showers';
    }

    if (code >= 95 && code <= 99) {
      return 'Thunderstorm';
    }

    return 'Unknown';
  }
}