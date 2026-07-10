import 'package:flutter/material.dart';

import 'core/app_router.dart';
import 'core/app_storage.dart';
import 'core/app_theme.dart';

final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedDarkMode =
      await AppStorage.isDarkMode();

  themeNotifier.value = savedDarkMode
      ? ThemeMode.dark
      : ThemeMode.light;

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (
        context,
        themeMode,
        child,
      ) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Weather App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}