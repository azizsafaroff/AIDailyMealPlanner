import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ChipOption extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;

  const ChipOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accentSurface : AppColors.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.chipBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 16, height: 1)),
                const SizedBox(width: 7),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? AppColors.accentDark : const Color(0xFF3A3A3A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChipGroupLabel extends StatelessWidget {
  final String text;
  const ChipGroupLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF5A5A5A),
      ),
    );
  }
}
