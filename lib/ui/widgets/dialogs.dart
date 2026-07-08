import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

Future<bool> showRemoveFoodDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove this food?', style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text(
        "Only remove foods you dislike or can't eat. If you have regenerate credits left today, "
        "we'll swap in a new AI pick automatically.",
        style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              side: const BorderSide(color: Color(0xFFDCDCDC)),
              foregroundColor: AppColors.textPrimary,
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<void> showNoCreditsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Out of regenerate credits', style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text(
        "You've used all 5 regenerations today, so this food was removed with no replacement. "
        "Fresh credits arrive tomorrow.",
        style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Got it'),
          ),
        ),
      ],
    ),
  );
}
