import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/character_search_provider.dart';
import 'filter_section.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterSearchProvider>(
      builder: (context, provider, _) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Results',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            provider.clearFilters();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: const Text('Clear All'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        FilterSection(
                          title: 'Status',
                          icon: Icons.favorite,
                          selectedValue: provider.selectedStatus,
                          options: const ['alive', 'dead', 'unknown'],
                          onChanged: provider.setStatusFilter,
                        ),
                        const SizedBox(height: 24),
                        FilterSection(
                          title: 'Species',
                          icon: Icons.pets,
                          selectedValue: provider.selectedSpecies,
                          options: const [
                            'Human',
                            'Alien',
                            'Humanoid',
                            'Robot',
                            'Animal',
                          ],
                          onChanged: provider.setSpeciesFilter,
                        ),
                        const SizedBox(height: 24),
                        FilterSection(
                          title: 'Gender',
                          icon: Icons.person,
                          selectedValue: provider.selectedGender,
                          options: const [
                            'female',
                            'male',
                            'genderless',
                            'unknown',
                          ],
                          onChanged: provider.setGenderFilter,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.background,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
