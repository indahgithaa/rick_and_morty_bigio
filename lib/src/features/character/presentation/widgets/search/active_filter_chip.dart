import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const ActiveFilterChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onDeleted,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.accent.withOpacity(0.3),
          highlightColor: AppColors.accent.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label[0].toUpperCase() + label.substring(1),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.close, size: 16, color: AppColors.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
