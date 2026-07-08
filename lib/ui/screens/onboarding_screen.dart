import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../logic/app_service.dart';
import '../../models/user_profile.dart';
import '../../theme/app_theme.dart';
import '../widgets/error_snackbar.dart';
import '../widgets/gradient_button.dart';
import '../widgets/profile_form_fields.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<ProfileFormFieldsState>();
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    final busy = context.select((AppService s) => s.busy);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 26, 16, 32),
                children: [
                  const Text(
                    'SET UP YOUR PLAN',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tell us about your goals',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      color: AppColors.textHeading,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "We'll build your first daily plan from these. You can change them "
                    'anytime in your profile.',
                    style: TextStyle(fontSize: 13, color: AppColors.textFainter, height: 1.5),
                  ),
                  const SizedBox(height: 22),
                  ProfileFormFields(
                    key: _formKey,
                    initial: UserProfile.defaultProfile,
                    onValidityChanged: (valid) => setState(() => _isValid = valid),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.borderFaint)),
              ),
              child: GradientButton(
                label: 'Create my plan',
                icon: LucideIcons.check,
                loading: busy,
                onPressed: busy || !_isValid
                    ? null
                    : () async {
                        final formState = _formKey.currentState;
                        if (formState == null || !formState.isValid) return;
                        final service = context.read<AppService>();
                        final success = await service.completeOnboarding(formState.result);
                        if (!success && context.mounted) {
                          showErrorSnackBar(context, service.errorMessage ?? 'Something went wrong.');
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
