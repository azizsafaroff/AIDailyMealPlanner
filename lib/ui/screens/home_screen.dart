import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../logic/app_service.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/dialogs.dart';
import '../widgets/error_snackbar.dart';
import '../widgets/gradient_button.dart';
import '../widgets/meal_section.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = [];
  bool _didAutoScroll = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeAutoScroll(int targetIndex) {
    if (_didAutoScroll) return;
    _didAutoScroll = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (targetIndex < 0 || targetIndex >= _sectionKeys.length) return;
      final context = _sectionKeys[targetIndex].currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        alignment: 0.08,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleRemove(AppService service, int mealIndex, int foodIndex) async {
    final confirmed = await showRemoveFoodDialog(context);
    if (!confirmed) return;
    final outcome = await service.removeFood(mealIndex, foodIndex);
    if (!mounted) return;
    if (outcome == RemoveFoodOutcome.removedNoCredits) {
      await showNoCreditsDialog(context);
    } else if (outcome == RemoveFoodOutcome.failed) {
      showErrorSnackBar(context, service.errorMessage ?? 'Something went wrong.');
    }
  }

  Future<void> _handleRegenerate(AppService service) async {
    final success = await service.regenerateToday();
    if (!success && mounted) {
      showErrorSnackBar(context, service.errorMessage ?? 'Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<AppService>();
    final plan = service.todayPlan;

    if (plan == null) {
      return _PlanErrorScreen(service: service);
    }

    if (_sectionKeys.length != plan.schedule.length) {
      _sectionKeys
        ..clear()
        ..addAll(List.generate(plan.schedule.length, (_) => GlobalKey()));
    }

    final currentIndex = service.currentMealIndex(plan);
    _maybeAutoScroll(currentIndex);

    return Scaffold(
      drawer: AppDrawer(
        targets: plan.dailyTargets,
        onHistory: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen()));
        },
        onProfile: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.borderFaint)),
              ),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => Material(
                      color: AppColors.surface,
                      shape: const CircleBorder(side: BorderSide(color: AppColors.borderStrong)),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(LucideIcons.menu, size: 20, color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                            color: AppColors.textHeading,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          '${DateFormat('EEE, MMM d').format(DateTime.now())} · ${plan.goal} · '
                          '${plan.totalCalories} kcal',
                          style: const TextStyle(fontSize: 12, color: AppColors.textFainter),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                children: [
                  for (var i = 0; i < plan.schedule.length; i++)
                    KeyedSubtree(
                      key: _sectionKeys[i],
                      child: MealSection(
                        meal: plan.schedule[i],
                        isCurrent: i == currentIndex,
                        isLast: i == plan.schedule.length - 1,
                        onRemoveFood: (foodIndex) => _handleRemove(service, i, foodIndex),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.borderFaint)),
              ),
              child: RegenerateButton(
                creditsRemaining: service.creditsRemaining,
                loading: service.busy,
                onPressed: () => _handleRegenerate(service),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanErrorScreen extends StatelessWidget {
  final AppService service;

  const _PlanErrorScreen({required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.cloudOff, size: 40, color: AppColors.textSubtle),
                const SizedBox(height: 16),
                const Text(
                  "Couldn't generate today's plan",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                if (service.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    service.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: AppColors.textFainter),
                  ),
                ],
                const SizedBox(height: 20),
                GradientButton(
                  label: 'Retry',
                  icon: LucideIcons.refreshCw,
                  loading: service.busy,
                  onPressed: service.busy ? null : () => service.retryTodayPlan(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
