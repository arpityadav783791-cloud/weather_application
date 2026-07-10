import 'package:go_router/go_router.dart';

import '../features/home_screen.dart';
import '../features/login_screen.dart';
import '../features/splash_screen.dart';
import 'app_storage.dart';
import 'package:weather_application/features/map_screen.dart';
import 'package:weather_application/features/saved_screen.dart';
import 'package:weather_application/features/profile_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',

  redirect: (context, state) async {
    final isLoggedIn = await AppStorage.isLoggedIn();

    final currentRoute = state.matchedLocation;

    if (currentRoute == '/splash') {
      return null;
    }

    final protectedRoutes = [
      '/home',
      '/map',
      '/saved',
      '/profile',
    ];

    if (!isLoggedIn && protectedRoutes.contains(currentRoute)) {
      return '/login';
    }

    if (isLoggedIn && currentRoute == '/login') {
      return '/home';
    }

    return null;
  },

  routes: [

    GoRoute(
      path: '/map',
      builder: (context, state) {
       return const MapScreen();
      },
    ),

    GoRoute(
      path: '/saved',
      builder: (context, state) {
        return const SavedScreen();
      },
    ),

    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ProfileScreen();
      },
    ),

    GoRoute(
      path: '/splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) {
        final city = state.uri.queryParameters["city"];
        return HomeScreen(
          initialCity: city,
        );
      },
    ),
  ],
);