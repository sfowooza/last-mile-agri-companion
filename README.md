# Farmer Companion (Last-Mile Agricultural Decision Companion)

Offline-first Flutter app for Ugandan smallholders. Android-first, Luganda-first.

## What's implemented (MVP skeleton)

| Pillar | Status | Notes |
|---|---|---|
| Offline photo diagnosis flow | ✅ Flow complete | Camera → crop hint → ranked results → voice reply |
| On-device AI model | ⚠️ **Seed classifier** | Deterministic placeholder; no trained vision model yet |
| Voice in / out | ✅ Wired | `flutter_tts` + `speech_to_text`, graceful fallback |
| Offline seasonal calendar | ✅ Seed data | Weekly tasks for 6 crops, personalised by farm profile |
| Crowdsourced prices | ✅ Local cache | Submit + view; sync is a stub until backend exists |
| Farm profile | ✅ Local | Crops, district, size, language — stored on device |
| Localization | ✅ 2 languages | Luganda (default) + English; new language = translation only |

## Quick start

```bash
cd /home/avodahdevops/last_mile_agri
flutter pub get
flutter analyze
flutter test

# Build for the x86_64 emulator
flutter build apk --debug --target-platform android-x64
adb -s emulator-5554 install -r build/app/outputs/flutter-apk/app-debug.apk
adb -s emulator-5554 shell monkey -p ug.co.lastmile.last_mile_agri \
  -c android.intent.category.LAUNCHER 1
```

## Important limitations

- **Not a trained model.** `SeedDiseaseClassifier` returns known conditions for
  the chosen crop with illustrative confidence values. Replace it with a
  quantised MobileNetV2/EfficientNet-Lite TFLite model once labelled Ugandan
  field photos exist. The UI is isolated from this via `DiseaseClassifier`.
- **Luganda voice quality depends on the device.** If a Luganda TTS/STT locale
  is unavailable, voice calls silently no-op and the text UI remains fully
  usable.
- **No backend / sync yet.** All data stays on the device via
  `shared_preferences`. `LocalStore` is the single place to add sync later.

## Architecture

```
lib/
  core/            l10n, models, local storage, voice service, theme
  features/
    diagnosis/     disease knowledge base + classifier interface + engine
    calendar/      offline seasonal task data
  ui/              onboarding, home shell, 4 feature screens
  app_state.dart   ChangeNotifier controller
```

Adding a language: add entries to `L10n._lg` / `L10n._en`, add an enum value,
add a TTS locale. No UI changes needed.

## Next steps (from the 90-day plan)

1. Interview 30–40 farmers (half women) in one district; finalise top 6–8 problems.
2. Collect 500–2000 labelled Ugandan field photos per major disease.
3. Train/fine-tune and swap in a real `DiseaseClassifier`.
4. Add NARO/CABI-reviewed advice content in natural spoken Luganda.
5. Add district-specific offline calendar packs and backend sync.
