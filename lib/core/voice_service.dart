import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'l10n.dart';

/// Voice in, voice out. Every method degrades to a no-op / false rather than
/// throwing, so a missing voice model never breaks the core diagnosis flow.
class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();
  bool _ttsReady = false;
  bool _sttReady = false;

  void Function(List<String>)? _finishActive;

  Future<void> init() async {
    try {
      await _tts.setSpeechRate(0.85);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _ttsReady = true;
    } catch (_) {
      _ttsReady = false;
    }

    try {
      _sttReady = await _stt.initialize(
        onError: (_) => _finishActive?.call(<String>[]),
        onStatus: (status) {
          if (status == SpeechToText.doneStatus ||
              status == SpeechToText.notListeningStatus ||
              status == 'notAvailable' ||
              status == 'aborted') {
            _finishActive?.call(<String>[]);
          }
        },
      );
    } catch (_) {
      _sttReady = false;
    }
  }

  Future<bool> speak(String text, AppLanguage language) async {
    if (!_ttsReady || text.trim().isEmpty) return false;
    try {
      await _tts.setLanguage(language.ttsLocale);
      await _tts.speak(text);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  /// Returns recognised words, or an empty list when STT is unavailable.
  Future<List<String>> listenOnce(AppLanguage language) async {
    if (!_sttReady) return [];

    final localeId = language == AppLanguage.lg ? 'lg_LG' : 'en_US';
    final available = (await _stt.locales()).map((l) => l.localeId).toList();
    final useLocale = available.contains(localeId)
        ? localeId
        : available.contains('en_US')
            ? 'en_US'
            : (available.isNotEmpty ? available.first : localeId);

    final completer = Completer<List<String>>();
    Timer? timeout;
    var finished = false;

    void finish(List<String> words) {
      if (finished) return;
      finished = true;
      timeout?.cancel();
      if (identical(_finishActive, finish)) _finishActive = null;
      if (!completer.isCompleted) completer.complete(words);
    }

    _finishActive = finish;

    try {
      await _stt.listen(
        localeId: useLocale,
        onResult: (result) {
          if (result.finalResult) {
            finish(result.recognizedWords.splitWhereEmpty());
          }
        },
      );
    } catch (_) {
      finish(<String>[]);
      return completer.future;
    }

    // Bound the listen window so the UI never hangs if the user says nothing.
    if (!finished) {
      timeout = Timer(const Duration(seconds: 8), () async {
        await _stt.stop();
        finish(<String>[]);
      });
    }

    return completer.future;
  }

  Future<void> stopListening() async {
    try {
      await _stt.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    await stop();
    await stopListening();
  }
}

extension on String {
  List<String> splitWhereEmpty() =>
      split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
}
