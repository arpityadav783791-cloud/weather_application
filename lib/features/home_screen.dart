import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:weather_application/core/app_storage.dart';
import 'weather_controller.dart';

class HomeScreen extends StatefulWidget {
  final String? initialCity;
  const HomeScreen({super.key, this.initialCity,});

  static const Color primaryBlue = Color(0xFF246BFD);
  static const Color background = Color(0xFFF4F7FC);
  static const Color darkText = Color(0xFF101828);
  static const Color secondaryText = Color(0xFF667085);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final WeatherController controller = Get.put(
    WeatherController(),

  );

  final TextEditingController searchController = TextEditingController();
  
  Color _surfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF10243C)
        : Colors.white;
  }

  Color _primaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : HomeScreen.darkText;
  }

  Color _secondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9CAEC4)
        : HomeScreen.secondaryText;
  }

  Color _dividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF29415E)
        : const Color(0xFFEEF2F7);
  }

  @override
  void initState() {
    super.initState();
    final city = widget.initialCity;
    if(city!=null && city.trim().isNotEmpty){
      controller.fetchWeather(city);
    }else{
      controller.fetchWeather('New Delhi');
    }
  }

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }

  String _formatDayName(String date) {
    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      return date;
    }

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[parsedDate.weekday - 1];
  }

  String _currentFormattedDate() {
    final now = DateTime.now();

    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];

    return '$weekday, ${now.day} $month';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final pageBackground = isDarkMode? const Color(0xFF06172D):HomeScreen.background;
    return Scaffold(
      backgroundColor: pageBackground,
      bottomNavigationBar: _buildBottomNavigation(),
      body: SafeArea(
        child: Obx(
          (){
          return  SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
          
                const SizedBox(height: 24),
          
                _buildSearchBar(),
          
                const SizedBox(height: 16),

                // loading indicator
                if(controller.isLoading.value)
                const LinearProgressIndicator(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),

                // Error message
                if(controller.errorMessage.value.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 12,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8E8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(
                      color: Color(0xFFB42318),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 24,),
          
                _buildMainWeatherCard(),
          
                const SizedBox(height: 28),
          
                _buildSectionHeader(
                  title: 'Hourly Forecast',
                  action: 'Next 24 hours',
                ),
          
                const SizedBox(height: 16),
          
                _buildHourlyForecast(),
          
                const SizedBox(height: 30),
          
                _buildSectionHeader(
                  title: 'Weather Details',
                ),
          
                const SizedBox(height: 16),
          
                _buildWeatherDetails(),
          
                const SizedBox(height: 30),
          
                _buildSectionHeader(
                  title: '7-Day Forecast',
                  action: 'View all',
                ),
          
                const SizedBox(height: 16),
          
                _buildWeeklyForecast(),
              ],
            ),
          );
        },
        ),
      ),
    );
  }

  IconData _weatherIcon(int code) {
    if (code == 0 || code == 1) {
      return Icons.wb_sunny_rounded;
    }

    if (code == 2 || code == 3) {
      return Icons.cloud_rounded;
    }

    if (code == 45 || code == 48) {
      return Icons.foggy;
    }

    if (code >= 51 && code <= 67) {
      return Icons.water_drop_rounded;
    }

    if (code >= 71 && code <= 77) {
      return Icons.ac_unit_rounded;
    }

    if (code >= 80 && code <= 82) {
      return Icons.umbrella_rounded;
    }

    if (code >= 85 && code <= 86) {
      return Icons.ac_unit_rounded;
    }

    if (code >= 95) {
      return Icons.thunderstorm_rounded;
    }
  
    return Icons.cloud_rounded;
  }

  Color _weatherIconColor(int code) {
    if (code == 0 || code == 1) {
      return const Color(0xFFFFB800);
    }

    if (code >= 51 && code <= 82) {
      return HomeScreen.primaryBlue;
    }

    return const Color(0xFF8A94A6);
  }

  Color _mainWeatherIconColor(int code) {
    if (code == 0 || code == 1) {
      return const Color(0xFFFFD54F);
    }
  
    if (code == 2 || code == 3) {
      return Colors.white;
    }

    if (code == 45 || code == 48) {
      return const Color(0xFFDCE6F2);
    }

    if (code >= 51 && code <= 67) {
      return const Color(0xFFBDE3FF);
    }

    if (code >= 71 && code <= 77) {
      return Colors.white;
    }

    if (code >= 80 && code <= 82) {
      return const Color(0xFFBDE3FF);
    }

    if (code >= 85 && code <= 86) {
      return Colors.white;
    }

    if (code >= 95 && code <= 99) {
      return const Color(0xFFFFD54F);
    }

    return Colors.white;
  }


  Widget _buildHourlyForecast() {
    final items = controller.hourlyForecast;

    if (items.isEmpty) {
      return const SizedBox(
        height: 145,
        child: Center(
          child: Text(
            'No hourly forecast available',
          ),
        ),
      );
    }

    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          final item = items[index];

          final selected = index == 0;

          final code =
              item['weatherCode'] as int;

          return Container(
            width: 86,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? HomeScreen.primaryBlue
                  : _surfaceColor(context),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.04,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  index == 0
                      ? 'Now'
                      : item['time'].toString(),
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : _secondaryTextColor(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 13),

                Icon(
                  _weatherIcon(code),
                  size: 31,
                  color: selected
                      ? Colors.white
                      : _weatherIconColor(code),
                ),

                const SizedBox(height: 13),

                Text(
                '${(item['temperature'] as double).round()}°',
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : _primaryTextColor(context),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          );
      },
      ),
    );
  }

  Widget _buildSearchBar() {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: _surfaceColor(context),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: 0.04,
          ),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: TextField(
      controller: searchController,
      style: TextStyle(
        color: _primaryTextColor(context),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        controller.fetchWeather(value);
      },
      decoration: InputDecoration(
        hintText: 'Search city...',
        hintStyle: TextStyle(
          color: _secondaryTextColor(context),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: _secondaryTextColor(context),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            controller.fetchWeather(
              searchController.text,
            );
          },
          icon: const Icon(
            Icons.search_rounded,
            color: HomeScreen.primaryBlue,
          ),
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
        ),
      ),
    ),
  );
}

  Widget _buildMainWeatherCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF256BFD),
          Color(0xFF4B8DFF),
          Color(0xFF72B5FF),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: HomeScreen.primaryBlue.withValues(
            alpha: 0.28,
          ),
          blurRadius: 30,
          offset: const Offset(0, 14),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _currentFormattedDate(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    '${controller.temperature.value.round()}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 76,
                      height: 0.95,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    controller.weatherCondition,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Feels like ${controller.feelsLike.value.round()}°',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 125,
              height: 125,
              child: Center(
                child: Icon(
                  _weatherIcon(
                    controller.weatherCode.value,
                  ),
                  size: 100,
                  color: _mainWeatherIconColor(
                    controller.weatherCode.value,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.16,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.15,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _MiniWeatherInfo(
                  icon: Icons.water_drop_outlined,
                  value: '${controller.humidity.value}%',
                  label: 'Humidity',
                ),
              ),

              const _VerticalDivider(),

              Expanded(
                child: _MiniWeatherInfo(
                  icon: Icons.air_rounded,
                  value:
                      '${controller.windSpeed.value.toStringAsFixed(1)} km/h',
                  label: 'Wind',
                ),
              ),

              const _VerticalDivider(),

              Expanded(
                child: _MiniWeatherInfo(
                  icon: Icons.speed_rounded,
                  value:
                      '${controller.pressure.value.round()} hPa',
                  label: 'Pressure',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSectionHeader({
    required String title,
    String? action,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: _primaryTextColor(context),
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: () {},
            child: Text(
              action,
              style: const TextStyle(
                color: HomeScreen.primaryBlue,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWeatherDetails() {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _DetailCard(
              icon: Icons.water_drop_rounded,
              iconColor: const Color(0xFF3B82F6),
              value: '${controller.humidity.value}%',
              label: 'Humidity',
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _DetailCard(
              icon: Icons.air_rounded,
              iconColor: const Color(0xFF10B981),
              value:
                  '${controller.windSpeed.value.toStringAsFixed(1)} km/h',
              label: 'Wind',
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      Row(
        children: [
          Expanded(
            child: _DetailCard(
              icon: Icons.speed_rounded,
              iconColor: const Color(0xFFF59E0B),
              value:
                  '${controller.pressure.value.round()} hPa',
              label: 'Pressure',
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _DetailCard(
              icon: Icons.thermostat_rounded,
              iconColor: const Color(0xFFEF4444),
              value:
                  '${controller.feelsLike.value.round()}°',
              label: 'Feels Like',
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildWeeklyForecast() {
    final days = controller.dailyForecast;

    if (days.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'No weekly forecast available',
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _surfaceColor(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: List.generate(
          days.length,
          (index) {
            final day = days[index];

            final code =
                day['weatherCode'] as int;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 82,
                        child: Text(
                          index == 0
                              ? 'Today'
                              : _formatDayName(
                                  day['date'].toString(),
                                ),
                          style: TextStyle(
                            color: _primaryTextColor(context),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Icon(
                        _weatherIcon(code),
                        color: _weatherIconColor(code),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          controller.conditionFromCode(
                            code,
                          ),
                          style: const TextStyle(
                            color:
                                HomeScreen.secondaryText,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Text(
                        '${(day['maxTemperature'] as double).round()}°',
                        style: TextStyle(
                          color: _primaryTextColor(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '${(day['minTemperature'] as double).round()}°',
                        style: TextStyle(
                          color: _primaryTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),

                if (index != days.length - 1)
                  Divider(
                    height: 1,
                    color: _dividerColor(context),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

 Widget _buildBottomNavigation() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: _surfaceColor(context),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            Expanded(
              child: _navItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: true,
                onTap: () => context.go('/home'),
              ),
            ),
            Expanded(
              child: _navItem(
                icon: Icons.map_outlined,
                label: 'Map',
                onTap: () => context.go('/map'),
              ),
            ),
            Expanded(
              child: _navItem(
                icon: Icons.favorite_border_rounded,
                label: 'Saved',
                onTap: () => context.go('/saved'),
              ),
            ),
            Expanded(
              child: _navItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                onTap: () => context.go('/profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _navItem({
    required IconData icon,
    required String label,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color:
                  selected ? HomeScreen.primaryBlue : const Color(0xFF98A2B3),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? HomeScreen.primaryBlue
                      : const Color(0xFF98A2B3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _surfaceColor(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child:  IconButton(
            onPressed: (){
              controller.fetchCurrentLocationWeather();
            },
            icon: const Icon(
              Icons.location_on_rounded,
              color: HomeScreen.primaryBlue,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Selected Location',
                style: TextStyle(
                  color: _secondaryTextColor(context),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 3),

              Row(
                children: [
                  Flexible(
                    child: Text(
                      '${controller.cityName.value}, '
                      '${controller.countryName.value}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _primaryTextColor(context),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: _primaryTextColor(context),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _surfaceColor(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () async {
                  final city = controller.cityName.value;

                  await AppStorage.saveCity(city);

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$city saved successfully',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.favorite_border_rounded,
                  color: HomeScreen.primaryBlue,
                ),
              ),
            ),

            const SizedBox(width: 8),

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _surfaceColor(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () async {
                  await AppStorage.logout();

                  if (!context.mounted) {
                    return;
                  }

                  context.go('/login');
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: _primaryTextColor(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniWeatherInfo extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MiniWeatherInfo({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 21,
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 45,
      color: Colors.white24,
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _DetailCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
Widget build(BuildContext context) {
  final isDarkMode =
      Theme.of(context).brightness == Brightness.dark;

  final cardColor = isDarkMode
      ? const Color(0xFF10243C)
      : Colors.white;

  final primaryTextColor = isDarkMode
      ? Colors.white
      : HomeScreen.darkText;

  final secondaryTextColor = isDarkMode
      ? const Color(0xFF9CAEC4)
      : HomeScreen.secondaryText;

  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: iconColor.withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                label,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}