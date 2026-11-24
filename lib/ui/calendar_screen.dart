import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../core/l10n.dart';
import '../features/calendar/calendar_data.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = L10nScope.of(context);
    final tasks = tasksForWeek(state.profile.crops, DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(l.t('thisWeek'))),
      body: SafeArea(
        child: tasks.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(l.t('noProfile'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                itemBuilder: (context, i) {
                  final task = tasks[i];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text('${i + 1}'),
                      ),
                      title: Text(task.title.get(state.language),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.detail.get(state.language)),
                            const SizedBox(height: 6),
                            Chip(label: Text(task.crop)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (tasks.isNotEmpty) {
            final text = tasks
                .map((t) => '${t.title.get(state.language)}. ${t.detail.get(state.language)}')
                .join(' ');
            state.voice.speak(text, state.language);
          }
        },
        child: const Icon(Icons.volume_up),
      ),
    );
  }
}
