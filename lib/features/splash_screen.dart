import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_application/core/app_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    final isLoggedIn = await AppStorage.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E5BC6),
              Color(0xFF4D9BFF),
              Color(0xFFB7D8FF),
              Color(0xFF123C7A),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 80,
                left: -40,
                child: _softCircle(
                  size: 180,
                  opacity: 0.08,
                ),
              ),

              Positioned(
                top: 200,
                right: -70,
                child: _softCircle(
                  size: 220,
                  opacity: 0.07,
                ),
              ),

              Column(
                children: [
                  const Spacer(flex: 2),

                  _buildWeatherIcon(),

                  const SizedBox(height: 28),

                  const Text(
                    'Weather',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Your daily forecast,\nanytime, anywhere.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const Spacer(flex: 3),

                  _buildLandscape(),

                  const SizedBox(height: 30),

                  const Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: const LinearProgressIndicator(
                        minHeight: 6,
                        backgroundColor: Color(0x66FFFFFF),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherIcon() {
    return const SizedBox(
      width: 150,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 15,
            child: Icon(
              Icons.wb_sunny_rounded,
              size: 65,
              color: Color(0xFFFFD54F),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 5,
            child: Icon(
              Icons.cloud_outlined,
              size: 115,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscape() {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: -40,
            bottom: 0,
            child: Transform.rotate(
              angle: 0.25,
              child: Container(
                width: 240,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF315FA8),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),

          Positioned(
            right: -40,
            bottom: 0,
            child: Transform.rotate(
              angle: -0.25,
              child: Container(
                width: 250,
                height: 125,
                decoration: BoxDecoration(
                  color: const Color(0xFF244F91),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 15,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFE9A8).withValues(
                  alpha: 0.75,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            child: Container(
              width: 120,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFF8FC5FF).withValues(
                  alpha: 0.5,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _softCircle({
    required double size,
    required double opacity,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(
          alpha: opacity,
        ),
      ),
    );
  }
}