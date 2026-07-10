import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_application/core/app_storage.dart';
import 'package:weather_application/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    isDarkMode =
        themeNotifier.value == ThemeMode.dark;
  }

  Future<void> _changeTheme(bool value) async {
    setState(() {
      isDarkMode = value;
    });

    themeNotifier.value = value
        ? ThemeMode.dark
        : ThemeMode.light;

    await AppStorage.saveTheme(value);
  }

  Future<void> _logout() async {
    await AppStorage.logout();

    if (!mounted) {
      return;
    }

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 44,
                    color: Color(0xFF246BFD),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Weather User',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Personal weather dashboard',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Preferences',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          Material(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: SwitchListTile(
              value: isDarkMode,
              onChanged: _changeTheme,
              secondary: const Icon(
                Icons.dark_mode_rounded,
                color: Color(0xFF246BFD),
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                isDarkMode
                    ? 'Dark theme enabled'
                    : 'Light theme enabled',
                style: TextStyle(
                  color: secondaryTextColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Account',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          Material(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              onTap: _logout,
              leading: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFEF4444),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/map');
              break;
            case 2:
              context.go('/saved');
              break;
            case 3:
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
            icon: Icon(
              Icons.favorite_border_rounded,
            ),
            selectedIcon: Icon(
              Icons.favorite_rounded,
            ),
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