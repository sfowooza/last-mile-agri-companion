import 'package:flutter_test/flutter_test.dart';

import 'package:last_mile_agri/features/diagnosis/diagnosis_engine.dart';

void main() {
  test('seed classifier returns up to three ranked results', () async {
    final classifier = SeedDiseaseClassifier();
    final results = await classifier.classify(
      imagePath: '/tmp/fake.jpg',
      cropHint: 'Maize',
    );
    expect(results.length, 3);
    expect(results.every((r) => r.disease.crop == 'Maize'), isTrue);
    expect(results.first.confidence, greaterThan(results.last.confidence));
  });
}
