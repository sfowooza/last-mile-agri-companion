import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'core/storage.dart';
import 'core/voice_service.dart';
import 'features/diagnosis/diagnosis_engine.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = LocalStore();
  await store.init();

  final voice = VoiceService();
  final engine = DiagnosisEngine(SeedDiseaseClassifier(), store);

  final state = AppState(store, voice, engine);
  await state.init();

  runApp(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: App(languageNotifier: state.languageNotifier),
    ),
  );
}
