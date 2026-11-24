import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../core/l10n.dart';
import '../core/models.dart';
import '../features/diagnosis/disease_data.dart';

class PricesScreen extends StatelessWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = L10nScope.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.t('prices'))),
      body: SafeArea(
        child: state.prices.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(l.t('pricesEmpty'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.prices.length,
                itemBuilder: (context, i) {
                  final p = state.prices[i];
                  return Card(
                    child: ListTile(
                      title: Text('${p.crop} — ${p.price.toStringAsFixed(0)} ${p.unit}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                      subtitle: Text('${p.market} · ${_when(p.reportedAt, l)}'),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const _AddPriceSheet(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _when(DateTime t, L10n l) {
    final diff = DateTime.now().difference(t).inHours;
    if (diff < 1) return l.isLg ? 'ensiije' : 'today';
    if (diff < 24) return '${diff}h';
    return '${diff ~/ 24}d';
  }
}

class _AddPriceSheet extends StatefulWidget {
  const _AddPriceSheet();

  @override
  State<_AddPriceSheet> createState() => _AddPriceSheetState();
}

class _AddPriceSheetState extends State<_AddPriceSheet> {
  final _market = TextEditingController();
  final _price = TextEditingController();
  String _crop = kCropNames.first;
  String _unit = 'kg';

  @override
  void dispose() {
    _market.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = double.tryParse(_price.text.trim());
    if (value == null || _market.text.trim().isEmpty) return;
    final state = context.read<AppState>();
    await state.addPrice(MarketPrice(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      market: _market.text.trim(),
      crop: _crop,
      price: value,
      unit: _unit,
      reportedAt: DateTime.now(),
    ));
    if (mounted) Navigator.pop(context);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10nScope.of(context).t('savedOffline'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Text(l.t('addPrice'), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          TextField(
            controller: _market,
            decoration: InputDecoration(labelText: l.t('market')),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _crop,
            decoration: InputDecoration(labelText: l.t('crop')),
            items: [
              for (final c in kCropNames)
                DropdownMenuItem(value: c, child: Text(c)),
            ],
            onChanged: (v) => setState(() => _crop = v!),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l.t('price')),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _unit,
                items: const [
                  DropdownMenuItem(value: 'kg', child: Text('kg')),
                  DropdownMenuItem(value: 'bag', child: Text('bag')),
                  DropdownMenuItem(value: 'crate', child: Text('crate')),
                ],
                onChanged: (v) => setState(() => _unit = v!),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: Text(l.t('submit'))),
        ],
      ),
    );
  }
}
