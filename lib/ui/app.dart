import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class App extends StatelessWidget {
  const App({super.key, required this.languageNotifier});

  final ValueNotifier<AppLanguage> languageNotifier;

  @override
  Widget build(BuildContext context) {
    return L10nScope(
      notifier: languageNotifier,
      child: MaterialApp(
        title: 'Farmer Companion',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const AppGate(),
      ),
    );
  }
}

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: state.profile.onboarded
          ? const HomeScreen(key: ValueKey('home'))
          : const OnboardingScreen(key: ValueKey('onboard')),
    );
  }
}
