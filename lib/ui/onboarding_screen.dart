import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../core/l10n.dart';
import '../core/models.dart';
import '../features/diagnosis/disease_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  late AppLanguage _language;
  final Set<String> _crops = {};
  String _district = kDistricts.first;

  @override
  void initState() {
    super.initState();
    _language = context.read<AppState>().language;
  }

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    final state = context.read<AppState>();
    state.completeOnboarding(FarmProfile(
      crops: _crops.toList(),
      district: _district,
      language: _language,
    ));
  }

  void _skip() {
    context.read<AppState>().completeOnboarding(
          FarmProfile(language: _language, onboarded: true),
        );
  }

  void _selectLanguage(AppLanguage lang) {
    setState(() => _language = lang);
    // Rebuild the whole tree so onboarding copy switches immediately.
    context.read<AppState>().setLanguage(lang);
  }

  @override
  Widget build(BuildContext context) {
    final l = L10nScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(l.t('skip')),
                ),
              ),
              const Spacer(),
              Icon(Icons.eco, size: 84, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text(l.t('welcome'), style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 12),
              Text(l.t('onboardIntro'), style: Theme.of(context).textTheme.bodyLarge),
              const Spacer(),
              if (_step == 0) _languageStep(l),
              if (_step == 1) _cropsStep(l),
              if (_step == 2) _districtStep(l),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _next,
                child: Text(_step == 2 ? l.t('done') : l.t('next')),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageStep(L10n l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.t('chooseLanguage'), style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        for (final lang in AppLanguage.values)
          RadioListTile<AppLanguage>(
            value: lang,
            groupValue: _language,
            title: Text(lang.label, style: const TextStyle(fontSize: 19)),
            onChanged: (v) => _selectLanguage(v!),
          ),
      ],
    );
  }

  Widget _cropsStep(L10n l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.t('chooseCrops'), style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final crop in kCropNames)
              FilterChip(
                label: Text(crop, style: const TextStyle(fontSize: 17)),
                selected: _crops.contains(crop),
                onSelected: (selected) {
                  setState(() {
                    selected ? _crops.add(crop) : _crops.remove(crop);
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _districtStep(L10n l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.t('chooseDistrict'), style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _district,
          items: [
            for (final d in kDistricts)
              DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 18))),
          ],
          onChanged: (v) => setState(() => _district = v!),
        ),
      ],
    );
  }
}
