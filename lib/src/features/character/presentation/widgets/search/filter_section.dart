import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class FilterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const FilterSection({
    super.key,
    required this.title,
    required this.icon,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.accent),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected =
                selectedValue?.toLowerCase() == option.toLowerCase();
            return FilterChip(
              label: Text(
                option[0].toUpperCase() + option.substring(1),
                style: TextStyle(
                  color: isSelected
                      ? AppColors.background
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onChanged(isSelected ? null : option),
              backgroundColor: AppColors.background,
              selectedColor: AppColors.accent,
              checkmarkColor: AppColors.background,
              showCheckmark: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
              pressElevation: 0,
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.accent
                      : AppColors.textSecondary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
