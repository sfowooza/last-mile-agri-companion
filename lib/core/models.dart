import 'l10n.dart';

/// Localised text holder. New languages add entries, not new UI code.
class LocalizedText {
  const LocalizedText(this.en, this.lg);
  final String en;
  final String lg;
  String get(AppLanguage lang) => lang == AppLanguage.lg ? lg : en;
}

class FarmProfile {
  const FarmProfile({
    this.crops = const [],
    this.district = '',
    this.farmSize = 0,
    this.language = AppLanguage.lg,
    this.onboarded = false,
  });

  final List<String> crops;
  final String district;
  final double farmSize;
  final AppLanguage language;
  final bool onboarded;

  FarmProfile copyWith({
    List<String>? crops,
    String? district,
    double? farmSize,
    AppLanguage? language,
    bool? onboarded,
  }) {
    return FarmProfile(
      crops: crops ?? this.crops,
      district: district ?? this.district,
      farmSize: farmSize ?? this.farmSize,
      language: language ?? this.language,
      onboarded: onboarded ?? this.onboarded,
    );
  }

  Map<String, dynamic> toJson() => {
        'crops': crops,
        'district': district,
        'farmSize': farmSize,
        'language': language.code,
        'onboarded': onboarded,
      };

  factory FarmProfile.fromJson(Map<String, dynamic> json) {
    return FarmProfile(
      crops: List<String>.from(json['crops'] as List? ?? []),
      district: json['district'] as String? ?? '',
      farmSize: (json['farmSize'] as num?)?.toDouble() ?? 0,
      language: json['language'] == 'en' ? AppLanguage.en : AppLanguage.lg,
      onboarded: json['onboarded'] as bool? ?? false,
    );
  }
}

class DiseaseInfo {
  const DiseaseInfo({
    required this.id,
    required this.crop,
    required this.name,
    required this.symptoms,
    required this.actions,
    this.nonChemical = true,
  });

  final String id;
  final String crop;
  final LocalizedText name;
  final LocalizedText symptoms;
  final LocalizedText actions;
  final bool nonChemical;
}

class DiagnosisResult {
  const DiagnosisResult({
    required this.disease,
    required this.confidence,
    this.imagePath,
    required this.at,
  });

  final DiseaseInfo disease;
  final double confidence;
  final String? imagePath;
  final DateTime at;

  Map<String, dynamic> toJson() => {
        'diseaseId': disease.id,
        'confidence': confidence,
        'imagePath': imagePath,
        'at': at.toIso8601String(),
      };
}

class MarketPrice {
  const MarketPrice({
    required this.id,
    required this.market,
    required this.crop,
    required this.price,
    required this.unit,
    required this.reportedAt,
    this.reporter = 'farmer',
  });

  final String id;
  final String market;
  final String crop;
  final double price;
  final String unit;
  final DateTime reportedAt;
  final String reporter;

  Map<String, dynamic> toJson() => {
        'id': id,
        'market': market,
        'crop': crop,
        'price': price,
        'unit': unit,
        'reportedAt': reportedAt.toIso8601String(),
        'reporter': reporter,
      };

  factory MarketPrice.fromJson(Map<String, dynamic> json) => MarketPrice(
        id: json['id'] as String,
        market: json['market'] as String,
        crop: json['crop'] as String,
        price: (json['price'] as num).toDouble(),
        unit: json['unit'] as String,
        reportedAt: DateTime.parse(json['reportedAt'] as String),
        reporter: json['reporter'] as String? ?? 'farmer',
      );
}

class CalendarTask {
  const CalendarTask({
    required this.id,
    required this.crop,
    required this.week,
    required this.title,
    required this.detail,
  });

  final String id;
  final String crop;
  final int week;
  final LocalizedText title;
  final LocalizedText detail;
}
