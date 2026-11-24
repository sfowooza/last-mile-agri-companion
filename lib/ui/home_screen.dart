import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/theme.dart';
import 'calendar_screen.dart';
import 'diagnosis_screen.dart';
import 'prices_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = L10nScope.of(context);
    final pages = [
      const DiagnosisScreen(),
      const CalendarScreen(),
      const PricesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.camera_alt_outlined),
            selectedIcon: const Icon(Icons.camera_alt, color: AppTheme.green),
            label: l.t('checkPlant'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month, color: AppTheme.green),
            label: l.t('thisWeek'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.price_change_outlined),
            selectedIcon: const Icon(Icons.price_change, color: AppTheme.green),
            label: l.t('prices'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: AppTheme.green),
            label: l.t('myFarm'),
          ),
        ],
      ),
    );
  }
}
