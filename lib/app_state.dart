import 'package:flutter/foundation.dart';

import 'core/l10n.dart';
import 'core/models.dart';
import 'core/storage.dart';
import 'core/voice_service.dart';
import 'features/diagnosis/diagnosis_engine.dart';

class AppState extends ChangeNotifier {
  AppState(this.store, this.voice, this.engine);

  final LocalStore store;
  final VoiceService voice;
  final DiagnosisEngine engine;

  late FarmProfile profile;
  late ValueNotifier<AppLanguage> languageNotifier;
  List<MarketPrice> prices = [];

  Future<void> init() async {
    profile = store.getProfile();
    languageNotifier = ValueNotifier(profile.language);
    prices = store.getPrices();
    await voice.init();
  }

  AppLanguage get language => languageNotifier.value;

  void setLanguage(AppLanguage lang) {
    languageNotifier.value = lang;
    profile = profile.copyWith(language: lang);
    store.saveProfile(profile);
    notifyListeners();
  }

  Future<void> saveProfile(FarmProfile updated) async {
    profile = updated;
    languageNotifier.value = updated.language;
    await store.saveProfile(updated);
    notifyListeners();
  }

  Future<void> completeOnboarding(FarmProfile updated) => saveProfile(
        updated.copyWith(onboarded: true),
      );

  Future<void> addPrice(MarketPrice price) async {
    await store.addPrice(price);
    prices = store.getPrices();
    notifyListeners();
  }
}
