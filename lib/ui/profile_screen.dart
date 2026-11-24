import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../core/l10n.dart';
import '../core/models.dart';
import '../features/diagnosis/disease_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = L10nScope.of(context);
    final profile = state.profile;

    return Scaffold(
      appBar: AppBar(title: Text(l.t('profile'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.t('crops'),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final crop in profile.crops)
                            Chip(label: Text(crop)),
                          if (profile.crops.isEmpty)
                            Text(l.t('noProfile')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('${l.t('district')}: ${profile.district}',
                          style: const TextStyle(fontSize: 17)),
                      const SizedBox(height: 6),
                      Text('${l.t('farmSize')}: ${profile.farmSize.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 17)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(l.t('chooseLanguage'),
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              for (final lang in AppLanguage.values)
                RadioListTile<AppLanguage>(
                  value: lang,
                  groupValue: state.language,
                  title: Text(lang.label),
                  onChanged: (v) => state.setLanguage(v!),
                ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const _EditFarmSheet(),
                ),
                icon: const Icon(Icons.edit),
                label: Text(l.t('saveProfile')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditFarmSheet extends StatefulWidget {
  const _EditFarmSheet();

  @override
  State<_EditFarmSheet> createState() => _EditFarmSheetState();
}

class _EditFarmSheetState extends State<_EditFarmSheet> {
  late Set<String> _crops;
  late String _district;
  late TextEditingController _size;

  @override
  void initState() {
    super.initState();
    final p = context.read<AppState>().profile;
    _crops = p.crops.toSet();
    _district = p.district.isEmpty ? kDistricts.first : p.district;
    _size = TextEditingController(text: p.farmSize.toString());
  }

  @override
  void dispose() {
    _size.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = L10nScope.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.t('saveProfile'), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final crop in kCropNames)
                FilterChip(
                  label: Text(crop),
                  selected: _crops.contains(crop),
                  onSelected: (v) => setState(() {
                    v ? _crops.add(crop) : _crops.remove(crop);
                  }),
                ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _district,
            decoration: InputDecoration(labelText: l.t('district')),
            items: [
              for (final d in kDistricts)
                DropdownMenuItem(value: d, child: Text(d)),
            ],
            onChanged: (v) => setState(() => _district = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _size,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l.t('farmSize')),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final size = double.tryParse(_size.text.trim());
              if (size == null || size < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a valid farm size')),
                );
                return;
              }
              final navigator = Navigator.of(context);
              await state.saveProfile(FarmProfile(
                crops: _crops.toList(),
                district: _district,
                farmSize: size,
                language: state.language,
                onboarded: true,
              ));
              navigator.pop();
            },
            child: Text(l.t('saveProfile')),
          ),
        ],
      ),
    );
  }
}
