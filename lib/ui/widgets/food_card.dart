import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../models/daily_plan.dart';
import '../../theme/app_theme.dart';
import '../food_glyph.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onRemove;

  const FoodCard({super.key, required this.food, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final parts = food.amount.trim().split(RegExp(r'\s+'));
    final amountValue = parts.isNotEmpty ? parts.first : food.amount;
    final amountUnit = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return Container(
      width: 100,
      padding: const EdgeInsets.fromLTRB(11, 12, 11, 11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.glyph.isNotEmpty ? food.glyph : foodGlyph(food.name),
                style: const TextStyle(fontSize: 24, height: 1),
              ),
              const SizedBox(height: 4),
              Text(
                food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.25),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    amountValue,
                    style: AppTheme.mono(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (amountUnit.isNotEmpty) ...[
                    const SizedBox(width: 3),
                    Text(
                      amountUnit,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSubtle),
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (onRemove != null)
            Positioned(
              top: -5,
              right: -4,
              child: Semantics(
                label: 'Remove food',
                button: true,
                child: Material(
                  color: AppColors.surface,
                  shape: const CircleBorder(side: BorderSide(color: AppColors.borderStrong)),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onRemove,
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(LucideIcons.thumbsDown, size: 12, color: Color(0xFFB4B4B4)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
