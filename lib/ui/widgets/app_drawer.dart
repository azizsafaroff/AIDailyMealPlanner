import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../models/daily_plan.dart';
import '../../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final DailyTargets? targets;
  final VoidCallback onHistory;
  final VoidCallback onProfile;

  const AppDrawer({
    super.key,
    required this.targets,
    required this.onHistory,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      width: 316,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                _RoundIconButton(
                  icon: LucideIcons.x,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (targets != null) _DailyTargetsCard(targets: targets!),
            if (targets != null) const SizedBox(height: 18),
            _NavRow(
              icon: LucideIcons.clock,
              title: 'History',
              subtitle: 'View past daily plans',
              onTap: onHistory,
            ),
            const SizedBox(height: 10),
            _NavRow(
              icon: LucideIcons.user,
              title: 'Edit profile',
              subtitle: 'Update goals and preferences',
              onTap: onProfile,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.borderStrong)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _DailyTargetsCard extends StatelessWidget {
  final DailyTargets targets;
  const _DailyTargetsCard({required this.targets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily targets', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  const Text('Live for today', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.4,
            children: [
              _TargetTile(label: 'Calories', valueAndUnit: targets.calories),
              _TargetTile(label: 'Protein', valueAndUnit: targets.protein),
              _TargetTile(label: 'Carbs', valueAndUnit: targets.carbs),
              _TargetTile(label: 'Fat', valueAndUnit: targets.fat),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderFaint),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.droplet, size: 18, color: AppColors.accent),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Water', style: TextStyle(fontSize: 11, color: AppColors.textSubtle)),
                    Text(targets.water, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetTile extends StatelessWidget {
  final String label;
  final String valueAndUnit;
  const _TargetTile({required this.label, required this.valueAndUnit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderFaint),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSubtle)),
          const SizedBox(height: 3),
          Text(
            valueAndUnit,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(color: AppColors.accentSurface, shape: BoxShape.circle),
                child: Icon(icon, size: 20, color: AppColors.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSubtle)),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFFC4C4C4)),
            ],
          ),
        ),
      ),
    );
  }
}
