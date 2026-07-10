import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_application/core/app_storage.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<String> savedCities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  Future<void> _loadSavedCities() async {
    final cities = await AppStorage.getSavedCities();

    if (!mounted) {
      return;
    }

    setState(() {
      savedCities = cities;
      isLoading = false;
    });
  }

  Future<void> _removeCity(String city) async {
    await AppStorage.removeSavedCity(city);

    await _loadSavedCities();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$city removed from saved cities',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Saved Cities',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : savedCities.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 64,
                        color: Color(0xFF98A2B3),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'No saved cities yet',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Save a city from the Home screen',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSavedCities,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: savedCities.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 12);
                    },
                    itemBuilder: (context, index) {
                      final city = savedCities[index];

                      return Material(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                        
                          leading: const CircleAvatar(
                            backgroundColor:
                                Color(0xFFE8F0FF),
                            child: Icon(
                              Icons.location_city_rounded,
                              color: Color(0xFF246BFD),
                            ),
                          ),
                        
                          title: Text(
                            city,
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        
                          subtitle: Text(
                            'Saved location',
                            style: TextStyle(
                              color: secondaryTextColor,
                            ),
                          ),
                        
                          trailing: IconButton(
                            onPressed: () {
                              _removeCity(city);
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        
                          onTap: () {
                            context.go(
                              '/home?city=${Uri.encodeComponent(city)}',
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;

            case 1:
              context.go('/map');
              break;

            case 2:
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