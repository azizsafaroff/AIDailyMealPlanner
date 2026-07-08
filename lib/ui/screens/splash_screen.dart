import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_theme.dart';
import '../widgets/gradient_button.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const SplashScreen({super.key, required this.onGetStarted});

  static const _features = [
    (icon: LucideIcons.refreshCw, text: 'A new plan generated for you each morning'),
    (icon: LucideIcons.thumbsDown, text: "Dislike a food? Swap it for an AI pick"),
    (icon: LucideIcons.droplet, text: 'Calories, macros and water, tracked for you'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradient,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Icon(LucideIcons.utensils, size: 46, color: Colors.white),
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'AI Daily Meal Planner',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                            color: AppColors.textStrong,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'One fresh, AI-built meal plan every day — tuned to your goals. '
                          "Swap anything you don't like, no logging required.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Color(0xFF6F6F6F), height: 1.55),
                        ),
                        const SizedBox(height: 26),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Column(
                            children: [
                              for (final ft in _features) ...[
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: AppColors.accentSurface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(ft.icon, size: 18, color: AppColors.accent),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        ft.text,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF4A4A4A),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (ft != _features.last) const SizedBox(height: 12),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.borderFaint)),
              ),
              child: Column(
                children: [
                  GradientButton(
                    label: 'Get started',
                    onPressed: onGetStarted,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Takes about 30 seconds · no account needed',
                    style: TextStyle(fontSize: 11, color: AppColors.textGhost),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
