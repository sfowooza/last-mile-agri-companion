import '../../core/models.dart';

/// Seed knowledge base. Content is intentionally short and spoken — long
/// paragraphs do not work for low-literacy, voice-first users.
/// Real deployments should replace/extend this with NARO + CABI reviewed copy.
const List<DiseaseInfo> kDiseases = [
  DiseaseInfo(
    id: 'maize_streak',
    crop: 'Maize',
    name: LocalizedText('Maize streak virus', 'Kabugwo k\'amayi'),
    symptoms: LocalizedText(
      'Yellow or white stripes along the leaves, stunted plants.',
      'Miryango emikuba oba emyeru ku makkati, ekimera kikendeera.',
    ),
    actions: LocalizedText(
      'Remove infected plants. Plant resistant seed next season. Control leafhoppers.',
      'Ggyaawo ebimera ebirwadde. Simba ensigo ezimirwako ng\'ogw\'omwaka ogujja. Kebera ebiwojjolo.',
    ),
  ),
  DiseaseInfo(
    id: 'maize_faw',
    crop: 'Maize',
    name: LocalizedText('Fall armyworm', 'Enkunge y\'amayi'),
    symptoms: LocalizedText(
      'Holes in leaves and sawdust-like frass in the funnel of the plant.',
      'Ebituli ku makkati n\'obucaafu ng\'ebisaanikuze mu mutima gw\'ekimera.',
    ),
    actions: LocalizedText(
      'Pick off caterpillars early. Crush egg masses. Use ash or neem where available. Spray only if infestation is heavy.',
      'Ggyaawo enkunge nga zito ntono. Ziyise amagi. Kozza evu oba emirandira gya neem. Fuyira singa zibeera nnyingi.',
    ),
  ),
  DiseaseInfo(
    id: 'maize_rust',
    crop: 'Maize',
    name: LocalizedText('Common rust', 'Engongo y\'amayi'),
    symptoms: LocalizedText(
      'Reddish-brown powdery pustules on both sides of leaves.',
      'Obufu obutukuvu ku makkati, ng\'obumyufu.',
    ),
    actions: LocalizedText(
      'Plant resistant varieties. Remove heavily infected leaves. Improve spacing for airflow.',
      'Simba ekika ekigumira. Ggyaawo amakkati agalwadde ennyo. Gatta ekifo ekimera gye kikulira.',
    ),
  ),
  DiseaseInfo(
    id: 'beans_anthracnose',
    crop: 'Beans',
    name: LocalizedText('Bean anthracnose', 'Kabugwo k\'ebijanjaalo'),
    symptoms: LocalizedText(
      'Dark sunken spots on pods and leaves; pods may rot.',
      'Amabala amaddugavu ku masavu n\'amakkati; amasavu gayinza okubola.',
    ),
    actions: LocalizedText(
      'Use certified seed. Avoid overhead watering. Remove infected pods. Rotate with maize for 2 seasons.',
      'Kozza ensigo eyakakasiddwa. Totamya waggulu. Ggyaawo amasavu agalwadde. Kyusa ekimera ne mayi emyaka ebiri.',
    ),
  ),
  DiseaseInfo(
    id: 'beans_fly',
    crop: 'Beans',
    name: LocalizedText('Bean fly', 'Enseenene y\'ebijanjaalo'),
    symptoms: LocalizedText(
      'Yellowing and wilting of young plants; swollen stem base.',
      'Ebimera ebito bifuula kyenvu era biggwa; ekisigizo kizzaamu.',
    ),
    actions: LocalizedText(
      'Plant early. Use seed dressing. Remove and destroy badly affected plants.',
      'Simba k\'umwanzo. Kozza eddagala ku nsigo. Ggyaawo ebimera ebirwadde ennyo obize.',
    ),
  ),
  DiseaseInfo(
    id: 'cassava_mosaic',
    crop: 'Cassava',
    name: LocalizedText('Cassava mosaic disease', 'Kabugwo k\'omuungu'),
    symptoms: LocalizedText(
      'Mosaic yellow/green patterns, twisted leaves, stunted growth.',
      'Ebifaananyi by\'ekyenvu n\'ekirungi ku makkati, amakkati gazimbulukuka.',
    ),
    actions: LocalizedText(
      'Plant resistant varieties. Use clean cuttings from healthy plants. Remove infected plants.',
      'Simba ebika ebimirwako. Kozza emiggo egiva ku bimera ebilamu. Ggyaawo ebirwadde.',
    ),
  ),
  DiseaseInfo(
    id: 'cassava_brown_streak',
    crop: 'Cassava',
    name: LocalizedText('Cassava brown streak', 'Obulwadde bwa kukala kwa muungu'),
    symptoms: LocalizedText(
      'Yellow leaf veins; brown, corky rot inside the root.',
      'Emisuwa gy\'amakkati gifuula kyenvu; munda y\'omuzi wuwo omukalu.',
    ),
    actions: LocalizedText(
      'Use resistant varieties and virus-free planting material. Report to extension officer.',
      'Kozza ebika ebimirwako n\'emiggo etalina k lwaddde. Mbuulira omukozi w\'ettaka.',
    ),
  ),
  DiseaseInfo(
    id: 'banana_bxw',
    crop: 'Banana',
    name: LocalizedText('Banana bacterial wilt (BXW)', 'Obulwadde bwa BBW ku muzungu'),
    symptoms: LocalizedText(
      'Yellowing leaves, wilting, reddish sap and rotting male flower.',
      'Amakkati gafuula kyenvu, gaggwa, amazzi amamyufu n\'ekimuli kigenda okubola.',
    ),
    actions: LocalizedText(
      'Cut and destroy infected plants. Sterilise tools with fire or disinfectant. Do not move infected suckers.',
      'Temamu era osaanyaawo ebimera ebirwadde. Yokya oba onyogoza ebyuma. Totwala bisigizo okuva ku kirwadde.',
    ),
  ),
  DiseaseInfo(
    id: 'coffee_rust',
    crop: 'Coffee',
    name: LocalizedText('Coffee leaf rust', 'Engongo y\'ekawa'),
    symptoms: LocalizedText(
      'Orange-yellow powder spots on the underside of leaves; leaves fall.',
      'Amabala aga kyenvu ku kasiita k\'amakkati; amakkati gagwa.',
    ),
    actions: LocalizedText(
      'Prune for airflow. Remove fallen leaves. Use approved fungicide only when needed, with extension guidance.',
      'Sala amatabi gakka. Ggyaawo amakkati agagwise. Kozza eddagala erikkiriziddwa ng\'omukozi w\'ettaka akulagidde.',
    ),
  ),
  DiseaseInfo(
    id: 'tomato_late_blight',
    crop: 'Tomato',
    name: LocalizedText('Late blight', 'Kabugwo k\'enyanya'),
    symptoms: LocalizedText(
      'Water-soaked dark spots on leaves and green/black patches on fruit.',
      'Amabala amaddugavu ng\'amazzi ku makkati n\'ekijju ku kibala.',
    ),
    actions: LocalizedText(
      'Remove infected leaves and fruits. Avoid wetting leaves. Improve spacing. Spray preventively in wet weather.',
      'Ggyaawo amakkati n\'ebibala ebirwadde. Totamya makkati. Gatta ekifo. Fuyira nga kutonnya.',
    ),
  ),
];

const List<String> kCropNames = [
  'Maize',
  'Beans',
  'Cassava',
  'Banana',
  'Coffee',
  'Tomato',
];

const List<String> kDistricts = [
  'Kampala',
  'Wakiso',
  'Mpigi',
  'Masaka',
  'Mbarara',
  'Kabale',
  'Gulu',
  'Lira',
  'Jinja',
  'Mbale',
  'Kasese',
  'Hoima',
];
