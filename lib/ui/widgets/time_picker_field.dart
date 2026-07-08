import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_theme.dart';

class TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;

  const TimePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF5A5A5A))),
        const SizedBox(height: 9),
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: value);
              if (picked != null) onChanged(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.clock, size: 18, color: AppColors.textSubtle),
                  const SizedBox(width: 10),
                  Text(value.format(context), style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
