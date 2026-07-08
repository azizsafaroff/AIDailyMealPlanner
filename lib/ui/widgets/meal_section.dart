import 'package:flutter/material.dart';

import '../../models/daily_plan.dart';
import '../../theme/app_theme.dart';
import 'food_card.dart';

class MealSection extends StatelessWidget {
  final MealEntry meal;
  final bool isCurrent;
  final bool isLast;
  final void Function(int foodIndex)? onRemoveFood;

  const MealSection({
    super.key,
    required this.meal,
    this.isCurrent = false,
    this.isLast = false,
    this.onRemoveFood,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: Column(
                children: [
                  const SizedBox(height: 2),
                  Text(
                    meal.time,
                    style: AppTheme.mono(
                      fontSize: 11,
                      color: AppColors.textSubtle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent ? AppColors.accent : Colors.white,
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.accent
                            : const Color(0xFFD5D5D5),
                        width: isCurrent ? 3 : 2,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E7EA),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.accentSurface
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCurrent
                        ? const Color(0xFFD9D3F7)
                        : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              children: [
                                Text(
                                  meal.meal,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (isCurrent)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'NOW',
                                      style: AppTheme.mono(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            '${meal.estimatedCalories} kcal',
                            style: AppTheme.mono(
                              fontSize: 12,
                              color: AppColors.textFaint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 128,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: meal.foods.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final food = meal.foods[i];
                          return FoodCard(
                            food: food,
                            onRemove: onRemoveFood != null
                                ? () => onRemoveFood!(i)
                                : null,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
