import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Everything is stored on the device. Sync is a no-op stub until a backend is
/// configured — the UI never blocks on the network.
class LocalStore {
  static const _kProfile = 'profile';
  static const _kPrices = 'prices';
  static const _kDiagnoses = 'diagnoses';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getStringList(_kPrices) == null) {
      await _prefs.setStringList(_kPrices, []);
    }
  }

  FarmProfile getProfile() {
    final raw = _prefs.getString(_kProfile);
    if (raw == null) return const FarmProfile();
    try {
      return FarmProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const FarmProfile();
    }
  }

  Future<void> saveProfile(FarmProfile profile) =>
      _prefs.setString(_kProfile, jsonEncode(profile.toJson()));

  List<MarketPrice> getPrices() {
    final prices = <MarketPrice>[];
    for (final raw in _prefs.getStringList(_kPrices) ?? []) {
      try {
        prices.add(MarketPrice.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {
        // Skip corrupt/legacy entries rather than crash the Prices screen.
      }
    }
    prices.sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
    return prices;
  }

  Future<void> addPrice(MarketPrice price) async {
    final list = (_prefs.getStringList(_kPrices) ?? [])..add(jsonEncode(price.toJson()));
    await _prefs.setStringList(_kPrices, list);
  }

  List<Map<String, dynamic>> getDiagnoses() {
    return (_prefs.getStringList(_kDiagnoses) ?? [])
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .toList();
  }

  Future<void> addDiagnosis(Map<String, dynamic> diagnosis) async {
    final list = (_prefs.getStringList(_kDiagnoses) ?? [])..add(jsonEncode(diagnosis));
    await _prefs.setStringList(_kDiagnoses, list);
  }
}
