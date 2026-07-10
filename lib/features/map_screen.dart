import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'weather_controller.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherController controller =
        Get.find<WeatherController>();

    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? const Color(0xFF06172D)
        : const Color(0xFFF4F7FC);

    final cardColor = isDarkMode
        ? const Color(0xFF10243C)
        : Colors.white;

    final primaryTextColor = isDarkMode
        ? Colors.white
        : const Color(0xFF101828);

    final secondaryTextColor = isDarkMode
        ? const Color(0xFF9CAEC4)
        : const Color(0xFF667085);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Weather Map'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(
        () {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(28),
                        child: CustomPaint(
                          painter: _MapBackgroundPainter(
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF246BFD),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF246BFD)
                                .withValues(alpha: 0.30),
                            blurRadius: 24,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    Positioned(
                      bottom: 18,
                      left: 18,
                      right: 18,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xE610243C)
                              : const Color(0xEEFFFFFF),
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_city_rounded,
                              color: Color(0xFF246BFD),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                '${controller.cityName.value}, '
                                '${controller.countryName.value}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            Text(
                              '${controller.temperature.value.round()}°',
                              style: const TextStyle(
                                color: Color(0xFF246BFD),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Current Conditions',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    _ConditionRow(
                      icon: Icons.thermostat_rounded,
                      label: 'Temperature',
                      value:
                          '${controller.temperature.value.round()}°',
                      textColor: primaryTextColor,
                      secondaryColor: secondaryTextColor,
                    ),

                    const Divider(height: 28),

                    _ConditionRow(
                      icon: Icons.water_drop_rounded,
                      label: 'Humidity',
                      value:
                          '${controller.humidity.value}%',
                      textColor: primaryTextColor,
                      secondaryColor: secondaryTextColor,
                    ),

                    const Divider(height: 28),

                    _ConditionRow(
                      icon: Icons.air_rounded,
                      label: 'Wind Speed',
                      value:
                          '${controller.windSpeed.value.toStringAsFixed(1)} km/h',
                      textColor: primaryTextColor,
                      secondaryColor: secondaryTextColor,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              break;
            case 2:
              context.go('/saved');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ConditionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color secondaryColor;

  const _ConditionRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF246BFD),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  final bool isDarkMode;

  _MapBackgroundPainter({
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = isDarkMode
          ? const Color(0xFF16314D)
          : const Color(0xFFE8F0FA);

    canvas.drawRect(
      Offset.zero & size,
      backgroundPaint,
    );

    final roadPaint = Paint()
      ..color = isDarkMode
          ? const Color(0xFF294B6A)
          : Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.15,
        size.width,
        size.height * 0.38,
      );

    final path2 = Path()
      ..moveTo(size.width * 0.20, 0)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.55,
        size.width * 0.75,
        size.height,
      );

    canvas.drawPath(path1, roadPaint);
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(
    covariant _MapBackgroundPainter oldDelegate,
  ) {
    return oldDelegate.isDarkMode != isDarkMode;
  }
}