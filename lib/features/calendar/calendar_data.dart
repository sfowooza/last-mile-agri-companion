import '../../core/models.dart';

/// A tiny offline seasonal calendar. Real deployments should load reviewed,
/// district-specific calendars from a bundled JSON asset, keyed by crop and
/// week. This seed set keeps the app useful with zero connectivity.
const List<CalendarTask> kCalendarTasks = [
  CalendarTask(
    id: 'maize_weed',
    crop: 'Maize',
    week: 1,
    title: LocalizedText('Weed your maize', 'Lima emayi'),
    detail: LocalizedText(
      'Remove weeds while the plants are young. Do not damage the roots.',
      'Ggyaawo enkunga ng\'ebimera bikyali bito. Tobikka musingi.',
    ),
  ),
  CalendarTask(
    id: 'maize_pest',
    crop: 'Maize',
    week: 2,
    title: LocalizedText('Watch for armyworm', 'Kebera enkunge'),
    detail: LocalizedText(
      'Check the funnel of each plant twice a week for caterpillars.',
      'Kebera mu mutima gw\'ekimera emiradi ebiri buli wiiki.',
    ),
  ),
  CalendarTask(
    id: 'maize_harvest',
    crop: 'Maize',
    week: 3,
    title: LocalizedText('Prepare for harvest', 'Tegeka okukungula'),
    detail: LocalizedText(
      'Check whether cobs are dry. Prepare dry storage to avoid mould.',
      'Kebera oba amayi gakaze. Tegeka ekifo ekikalu okugahagaawo.',
    ),
  ),
  CalendarTask(
    id: 'beans_weed',
    crop: 'Beans',
    week: 1,
    title: LocalizedText('Weed beans gently', 'Lima ebijanjaalo mpola'),
    detail: LocalizedText(
      'Shallow weed only — bean roots are close to the surface.',
      'Lima katono — emisingi gya bijanjaalo giri kumpi n\'ettaka.',
    ),
  ),
  CalendarTask(
    id: 'beans_pod',
    crop: 'Beans',
    week: 2,
    title: LocalizedText('Check pods for spots', 'Kebera amasavu'),
    detail: LocalizedText(
      'Look for dark spots on pods. Remove and destroy affected pods.',
      'Kebera amabala amaddugavu ku masavu. Gagyaawo ogozaamu.',
    ),
  ),
  CalendarTask(
    id: 'cassava_cuttings',
    crop: 'Cassava',
    week: 1,
    title: LocalizedText('Select healthy cuttings', 'Londa emiggo emiramu'),
    detail: LocalizedText(
      'Take cuttings only from plants with no mosaic symptoms.',
      'Kozza emiggo okuva ku bimera ebitalina kabugwo.',
    ),
  ),
  CalendarTask(
    id: 'banana_prune',
    crop: 'Banana',
    week: 2,
    title: LocalizedText('Remove old leaves', 'Ggyaawo amakkati amakadde'),
    detail: LocalizedText(
      'Cut off old and diseased leaves to improve airflow.',
      'Salawo amakkati amakadde n\'agalwadde.',
    ),
  ),
  CalendarTask(
    id: 'coffee_prune',
    crop: 'Coffee',
    week: 1,
    title: LocalizedText('Prune coffee', 'Sala ekawa'),
    detail: LocalizedText(
      'Remove dead branches and suckers to let air and light in.',
      'Ggyaawo amatabi agafu n\'amasigizo.',
    ),
  ),
  CalendarTask(
    id: 'tomato_stake',
    crop: 'Tomato',
    week: 1,
    title: LocalizedText('Stake tomato plants', 'Simbisa enyanya'),
    detail: LocalizedText(
      'Stake plants and remove lower leaves to keep fruit off the soil.',
      'Waniriza ebimera oggyawo amakkati wansi.',
    ),
  ),
];

/// ISO week number (1–53) — stable for the whole Mon–Sun week.
int _isoWeek(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final thursday = day.add(Duration(days: 4 - day.weekday));
  final yearStart = DateTime.utc(thursday.year, 1, 1);
  return ((thursday.difference(yearStart).inDays) ~/ 7) + 1;
}

/// Tasks for the current week, personalised to the farmer's crops.
List<CalendarTask> tasksForWeek(List<String> crops, DateTime now) {
  final normalized = 1 + (_isoWeek(now) % 3);
  return kCalendarTasks
      .where((t) => crops.contains(t.crop) && t.week == normalized)
      .toList();
}
