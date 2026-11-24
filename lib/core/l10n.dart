import 'package:flutter/widgets.dart';

/// Supported interface languages. Luganda first — this is a Luganda-first app.
enum AppLanguage { lg, en }

extension AppLanguageX on AppLanguage {
  String get code => this == AppLanguage.lg ? 'lg' : 'en';
  String get ttsLocale => this == AppLanguage.lg ? 'lg-UG' : 'en-US';
  String get label => this == AppLanguage.lg ? 'Luganda' : 'English';
}

/// Tiny two-language string catalogue. Deliberately plain Maps so adding a new
/// language is translation work only — no UI rewrites.
class L10n {
  L10n(this.language);

  final AppLanguage language;
  bool get isLg => language == AppLanguage.lg;

  static const Map<String, String> _lg = {
    'appName': 'Omulimi',
    'checkPlant': 'Kebera ekimera',
    'thisWeek': 'Kuno kwe Sunday',
    'prices': 'Emiwendo',
    'myFarm': 'Famu yange',
    'welcome': 'Kusanyu okukwatagana naffe',
    'onboardIntro': 'Tukuyamba okumanya ekiri ku bimera byo, n\'amawulire g\'ettaka n\'emisolo — n\'awatali internet.',
    'chooseLanguage': 'Londa olulimi',
    'chooseCrops': 'Londa ebimera byo',
    'chooseDistrict': 'Londa disitulikiti yo',
    'skip': 'Sambuka',
    'next': 'Okula',
    'done': 'Kamala',
    'takePhoto': 'Teka ekifaananyi',
    'guidance': 'Kwata foni n\'olamu, ekifaananyi kirungi, ekimera kijule mu kifaananyi.',
    'analyzing': 'Ekebera...',
    'possibleProblem': 'Ekiyinza okuba ekizibu',
    'confidence': 'Amaanyi g\'okumanya',
    'whatToDo': 'Eky\'okukola',
    'hearAgain': 'Bazzaayo owulire',
    'save': 'Hagaawo',
    'noCamera': 'Tewali kamera',
    'lowConfidence': 'Tumanya kitono. Buuza omukozi w\'ettaka.',
    'weeklyActions': 'Eby\'okukola kuno kwe Sunday',
    'noProfile': 'Tewali famu. Londa ebimera byo mu Famu yange.',
    'pricesEmpty': 'Tewali miwendo. Yongerako omuwendo.',
    'addPrice': 'Yongerako omuwendo',
    'market': 'Katale',
    'crop': 'Ekimera',
    'price': 'Omuwendo',
    'unit': 'Ekipimo',
    'submit': 'Tuma',
    'savedOffline': 'Kisigazibbwa mu foni',
    'profile': 'Famu yange',
    'crops': 'Ebimera',
    'district': 'Disitulikiti',
    'farmSize': 'Obunene bwa famu (hectares)',
    'saveProfile': 'Hagaawo',
    'voiceHint': 'Bazzaayo owulire oba oyogere',
    'listen': 'Wulira',
    'stop': 'Yimuka',
    'offlineReady': 'Ekola n\'awatali internet',
    'demoNotice': 'Eki kigezo kya demo — ssi AI eyatendezebwa. Buuza omukozi w\'ettaka.',
    'listening': 'Nwulira...',
    'voiceFailed': 'Teññegezze. Gezaako nate.',
  };

  static const Map<String, String> _en = {
    'appName': 'Farmer Companion',
    'checkPlant': 'Check Plant',
    'thisWeek': 'This Week',
    'prices': 'Prices',
    'myFarm': 'My Farm',
    'welcome': 'Welcome to Farmer Companion',
    'onboardIntro': 'We help you understand what is wrong with your crops, get seasonal advice and market prices — even without internet.',
    'chooseLanguage': 'Choose language',
    'chooseCrops': 'Choose your crops',
    'chooseDistrict': 'Choose your district',
    'skip': 'Skip',
    'next': 'Next',
    'done': 'Done',
    'takePhoto': 'Take a photo',
    'guidance': 'Hold steady, use good light, fill the frame with the plant.',
    'analyzing': 'Checking...',
    'possibleProblem': 'Possible problem',
    'confidence': 'Confidence',
    'whatToDo': 'What to do',
    'hearAgain': 'Hear again',
    'save': 'Save',
    'noCamera': 'No camera available',
    'lowConfidence': 'We are not sure. Please confirm with an extension worker.',
    'weeklyActions': 'Your actions this week',
    'noProfile': 'No farm set up. Choose your crops in My Farm.',
    'pricesEmpty': 'No prices yet. Add one.',
    'addPrice': 'Add a price',
    'market': 'Market',
    'crop': 'Crop',
    'price': 'Price',
    'unit': 'Unit',
    'submit': 'Submit',
    'savedOffline': 'Saved on this phone',
    'profile': 'My Farm',
    'crops': 'Crops',
    'district': 'District',
    'farmSize': 'Farm size (hectares)',
    'saveProfile': 'Save',
    'voiceHint': 'Tap to hear or speak',
    'listen': 'Listen',
    'stop': 'Stop',
    'offlineReady': 'Works offline',
    'demoNotice': 'Demo mode: seed classifier, not a trained AI. Always confirm with an extension worker.',
    'listening': 'Listening...',
    'voiceFailed': 'Could not understand. Try again.',
  };

  String t(String key) => (isLg ? _lg : _en)[key] ?? _en[key] ?? key;
}

/// Inherited widget so the whole tree can read the current language.
class L10nScope extends InheritedNotifier<ValueNotifier<AppLanguage>> {
  const L10nScope({
    super.key,
    required ValueNotifier<AppLanguage> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static L10n of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<L10nScope>();
    assert(scope != null, 'L10nScope missing');
    return L10n(scope!.notifier!.value);
  }
}
