import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/extensions/ui_state_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/character_search_provider.dart';
import '../character_card.dart';
import '../empty_state_widget.dart';
import '../error_state_widget.dart';

class SearchResultsWidget extends StatelessWidget {
  final String searchQuery;
  final Function(int) onCharacterTap;
  final VoidCallback onRetry;

  const SearchResultsWidget({
    super.key,
    required this.searchQuery,
    required this.onCharacterTap,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterSearchProvider>(
      builder: (context, provider, _) {
        return provider.state.when(
          onLoading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.accent),
                SizedBox(height: 16),
                Text(
                  'Searching...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          onSuccess: (characters) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Found ${characters.length} character${characters.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: characters.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final character = characters[index];
                      return CharacterCard(
                        character: character,
                        onTap: () => onCharacterTap(character.id),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          onError: (message) =>
              ErrorStateWidget(message: message, onRetry: onRetry),
          onEmpty: () => EmptyStateWidget(
            message: searchQuery.isEmpty
                ? 'Search or use filters to find characters'
                : 'No characters found',
          ),
        );
      },
    );
  }
}
