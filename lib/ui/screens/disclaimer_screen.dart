import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../logic/app_service.dart';
import '../../theme/app_theme.dart';
import '../widgets/gradient_button.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 32, 30, 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(LucideIcons.shieldAlert, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Before you start',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'AI Daily Meal Planner gives general nutrition suggestions based on what '
                      'you tell us — it is not medical advice. It is not a substitute for '
                      'professional medical guidance, diagnosis, or treatment.\n\n'
                      'If you have a medical condition, allergy risk, or are otherwise under '
                      'the care of a doctor or dietitian, please consult them before following '
                      'any plan generated here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF6F6F6F), height: 1.55),
                    ),
                  ],
                ),
              ),
              GradientButton(
                label: 'I understand, continue',
                onPressed: () => context.read<AppService>().acceptDisclaimer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
