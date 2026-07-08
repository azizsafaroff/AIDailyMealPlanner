import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../logic/app_service.dart';
import '../../models/daily_plan.dart';
import '../../theme/app_theme.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<(String, DailyPlan?)>> _future;

  @override
  void initState() {
    super.initState();
    final service = context.read<AppService>();
    _future = Future.wait(
      service.historyIndex.map(
        (date) async => (date, await service.loadHistoryDetail(date)),
      ),
    );
  }

  String _formatDate(String dateKey) {
    final date = DateTime.parse(dateKey);
    return DateFormat('EEE, MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder<List<(String, DailyPlan?)>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data!.where((e) => e.$2 != null).toList();
          if (entries.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No past plans yet. Come back tomorrow to see your history here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textFainter),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final (date, plan) = entries[i];
              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => HistoryDetailScreen(dateKey: date)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(LucideIcons.calendar, size: 20, color: AppColors.textMuted),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_formatDate(date), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(plan!.goal, style: const TextStyle(fontSize: 12, color: AppColors.textSubtle)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${plan.totalCalories}',
                              style: AppTheme.mono(fontSize: 13, color: const Color(0xFF5A5A5A)),
                            ),
                            const Text('kcal', style: TextStyle(fontSize: 10, color: AppColors.textPale)),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFFC4C4C4)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
