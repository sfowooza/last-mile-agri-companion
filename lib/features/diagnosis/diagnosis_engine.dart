import 'dart:math';

import '../../core/models.dart';
import '../../core/storage.dart';
import 'disease_data.dart';

/// Swap this out for a TFLite / ONNX model without touching any UI code.
abstract class DiseaseClassifier {
  Future<List<DiagnosisResult>> classify({
    required String imagePath,
    String? cropHint,
  });
}

/// Deterministic seed classifier.
///
/// IMPORTANT: this is NOT a trained vision model. It returns the known
/// conditions for the selected crop so the full user flow can be validated in
/// the field before collecting training data. Replace with a quantised
/// MobileNetV2/EfficientNet-Lite model once labelled Ugandan field photos
/// exist. The confidence values are placeholders too.
class SeedDiseaseClassifier implements DiseaseClassifier {
  SeedDiseaseClassifier({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  Future<List<DiagnosisResult>> classify({
    required String imagePath,
    String? cropHint,
  }) async {
    // Simulate on-device inference latency so the UI flow feels real.
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final candidates = cropHint == null
        ? kDiseases
        : kDiseases.where((d) => d.crop == cropHint).toList();
    final pool = candidates.isEmpty ? kDiseases : candidates;

    // Spread the pool with a small deterministic jitter so repeated runs are
    // stable enough for demo/testing but not identical.
    final now = DateTime.now();
    final ordered = [...pool]..sort((a, b) {
        final aKey = '${now.millisecond}${a.id}';
        final bKey = '${now.millisecond}${b.id}';
        return bKey.compareTo(aKey);
      });

    return ordered.take(3).map((disease) {
      final base = 0.82 - (ordered.indexOf(disease) * 0.19);
      final confidence = (base + _random.nextDouble() * 0.06).clamp(0.18, 0.92);
      return DiagnosisResult(
        disease: disease,
        confidence: confidence.toDouble(),
        imagePath: imagePath,
        at: DateTime.now(),
      );
    }).toList();
  }
}

class DiagnosisEngine {
  DiagnosisEngine(this._classifier, this._store);

  final DiseaseClassifier _classifier;
  final LocalStore _store;

  Future<List<DiagnosisResult>> diagnose(String imagePath, String? cropHint) async {
    final results = await _classifier.classify(imagePath: imagePath, cropHint: cropHint);
    for (final result in results) {
      await _store.addDiagnosis(result.toJson());
    }
    return results;
  }
}
