import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/character_search_provider.dart';
import 'active_filter_chip.dart';

class ActiveFiltersWidget extends StatelessWidget {
  const ActiveFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterSearchProvider>(
      builder: (context, provider, _) {
        final hasFilters =
            provider.selectedStatus != null ||
            provider.selectedSpecies != null ||
            provider.selectedGender != null;

        if (!hasFilters) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(
              bottom: BorderSide(color: AppColors.surface, width: 1),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Filters: ',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                if (provider.selectedStatus != null) ...[
                  ActiveFilterChip(
                    label: provider.selectedStatus!,
                    onDeleted: () => provider.setStatusFilter(null),
                  ),
                  const SizedBox(width: 8),
                ],
                if (provider.selectedSpecies != null) ...[
                  ActiveFilterChip(
                    label: provider.selectedSpecies!,
                    onDeleted: () => provider.setSpeciesFilter(null),
                  ),
                  const SizedBox(width: 8),
                ],
                if (provider.selectedGender != null)
                  ActiveFilterChip(
                    label: provider.selectedGender!,
                    onDeleted: () => provider.setGenderFilter(null),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
