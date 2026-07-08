import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../logic/app_service.dart';
import '../../theme/app_theme.dart';
import '../widgets/error_snackbar.dart';
import '../widgets/profile_form_fields.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<ProfileFormFieldsState>();
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<AppService>();
    final profile = service.profile!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  ProfileFormFields(
                    key: _formKey,
                    initial: profile,
                    onValidityChanged: (valid) => setState(() => _isValid = valid),
                  ),
                  if (service.profileSaveUsesBonus) ...[
                    const SizedBox(height: 20),
                    _InlineNote(
                      icon: LucideIcons.alertTriangle,
                      text: "You're using your one bonus save for today. Any changes after "
                          'this stay locked until tomorrow.',
                    ),
                  ] else if (service.profileSaveBlocked) ...[
                    const SizedBox(height: 20),
                    _InlineNote(
                      icon: LucideIcons.lock,
                      text: "You've used today's regenerate credits and your bonus save. "
                          'Editing your profile will unlock again tomorrow.',
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.borderFaint)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        side: const BorderSide(color: Color(0xFFDCDCDC)),
                        foregroundColor: AppColors.textPrimary,
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: service.profileSaveBlocked || service.busy || !_isValid
                          ? null
                          : () async {
                              final formState = _formKey.currentState;
                              if (formState == null || !formState.isValid) return;
                              final outcome = await service.updateProfile(formState.result);
                              if (!context.mounted) return;
                              if (outcome == ProfileSaveOutcome.failed) {
                                showErrorSnackBar(context, service.errorMessage ?? 'Something went wrong.');
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        backgroundColor: AppColors.accent,
                        disabledBackgroundColor: AppColors.disabled,
                        foregroundColor: Colors.white,
                      ),
                      child: service.busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text('Save', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
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

class _InlineNote extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InlineNote({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.warningIcon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: AppColors.warningText, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
