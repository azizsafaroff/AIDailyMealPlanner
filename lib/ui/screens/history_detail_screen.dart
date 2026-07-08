import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../logic/app_service.dart';
import '../../models/daily_plan.dart';
import '../../theme/app_theme.dart';
import '../widgets/meal_section.dart';

class HistoryDetailScreen extends StatefulWidget {
  final String dateKey;

  const HistoryDetailScreen({super.key, required this.dateKey});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  late Future<DailyPlan?> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AppService>().loadHistoryDetail(widget.dateKey);
  }

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('EEE, MMM d').format(DateTime.parse(widget.dateKey));

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: FutureBuilder<DailyPlan?>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final plan = snapshot.data;
          if (plan == null) {
            return const Center(child: Text('No plan saved for this date.'));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(plan.goal, style: const TextStyle(fontSize: 13, color: AppColors.textFainter)),
                  Text(
                    '${plan.totalCalories} kcal total',
                    style: AppTheme.mono(fontSize: 13, color: const Color(0xFF5A5A5A)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < plan.schedule.length; i++)
                MealSection(
                  meal: plan.schedule[i],
                  isLast: i == plan.schedule.length - 1,
                ),
            ],
          );
        },
      ),
    );
  }
}
