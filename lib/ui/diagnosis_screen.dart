import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../core/l10n.dart';
import '../core/models.dart';
import '../core/theme.dart';
import '../features/diagnosis/disease_data.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  File? _image;
  String? _crop;
  bool _analyzing = false;
  bool _listening = false;
  List<DiagnosisResult>? _results;

  @override
  void initState() {
    super.initState();
    final crops = context.read<AppState>().profile.crops;
    _crop = crops.isNotEmpty ? crops.first : null;
  }

  Future<void> _pick() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required')),
        );
      }
      return;
    }
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (x != null && mounted) setState(() => _image = File(x.path));
  }

  /// Voice input for low-literacy users: say the crop name to select it.
  Future<void> _listenCrop() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted || !mounted) return;
    setState(() => _listening = true);
    final state = context.read<AppState>();
    final l = L10nScope.of(context);
    final words = await state.voice.listenOnce(state.language);
    if (!mounted) return;
    setState(() => _listening = false);
    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.t('voiceFailed'))),
      );
      return;
    }
    final spoken = words.join(' ').toLowerCase();
    for (final crop in kCropNames) {
      if (spoken.contains(crop.toLowerCase())) {
        setState(() => _crop = crop);
        await state.voice.speak(crop, state.language);
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.t('voiceFailed'))),
    );
  }

  Future<void> _stopListening() async {
    await context.read<AppState>().voice.stopListening();
    if (mounted) setState(() => _listening = false);
  }

  Future<void> _analyze() async {
    if (_image == null) return;
    setState(() => _analyzing = true);
    final state = context.read<AppState>();
    final results = await state.engine.diagnose(_image!.path, _crop);
    if (!mounted) return;
    if (results.isEmpty) {
      setState(() => _analyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No result. Try another photo.')),
      );
      return;
    }
    setState(() {
      _results = results;
      _analyzing = false;
    });
  }

  void _reset() => setState(() {
        _image = null;
        _results = null;
      });

  @override
  Widget build(BuildContext context) {
    final l = L10nScope.of(context);
    if (_results != null) {
      return _ResultView(results: _results!, onBack: _reset);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.t('checkPlant')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: const Icon(Icons.wifi_off, size: 16),
              label: Text(l.t('offlineReady'), style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(child: Text(l.t('demoNotice'))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.t('guidance'), style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              DropdownButtonFormField<String?>(
                initialValue: _crop,
                decoration: InputDecoration(labelText: l.t('crop')),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('—')),
                  for (final crop in kCropNames)
                    DropdownMenuItem(value: crop, child: Text(crop)),
                ],
                onChanged: (v) => setState(() => _crop = v),
              ),
              const SizedBox(height: 10),
              if (_listening)
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(l.t('listening')),
                    const Spacer(),
                    TextButton(onPressed: _stopListening, child: Text(l.t('stop'))),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: _listenCrop,
                  icon: const Icon(Icons.mic),
                  label: Text(l.t('voiceHint')),
                ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _analyzing ? null : _pick,
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.green.withValues(alpha: 0.4), width: 2),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 72, color: AppTheme.green),
                            const SizedBox(height: 12),
                            Text(l.t('takePhoto'),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(_image!, fit: BoxFit.cover, width: double.infinity),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              _analyzing
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton.icon(
                      onPressed: _image == null ? null : _analyze,
                      icon: const Icon(Icons.search),
                      label: Text(l.t('checkPlant')),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({required this.results, required this.onBack});

  final List<DiagnosisResult> results;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = L10nScope.of(context);
    final top = results.first;
    final low = top.confidence < 0.55;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.t('possibleProblem')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(child: Text(l.t('demoNotice'))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (low)
                Card(
                  color: Colors.amber.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(child: Text(l.t('lowConfidence'))),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              for (final result in results)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.disease.name.get(state.language),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('${l.t('confidence')}: ${(result.confidence * 100).round()}%'),
                        LinearProgressIndicator(
                          value: result.confidence,
                          minHeight: 8,
                          color: AppTheme.green,
                        ),
                        const SizedBox(height: 14),
                        Text(result.disease.symptoms.get(state.language),
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 14),
                        Text(l.t('whatToDo'),
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                        const SizedBox(height: 6),
                        Text(result.disease.actions.get(state.language),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => state.voice.speak(
                  '${top.disease.name.get(state.language)}. ${top.disease.actions.get(state.language)}',
                  state.language,
                ),
                icon: const Icon(Icons.volume_up),
                label: Text(l.t('hearAgain')),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.check),
                label: Text(l.t('done')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
