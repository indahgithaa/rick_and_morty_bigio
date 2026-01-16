import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/src/core/extensions/ui_state_extension.dart';
import '../../../../core/router/route_names.dart';
import '../providers/favorite_provider.dart';
import '../widgets/character_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().fetchFavorites();
    });
  }

  void _navigateToDetail(int characterId) async {
    await Navigator.pushNamed(
      context,
      RouteNames.characterDetail,
      arguments: characterId,
    );
    if (mounted) {
      context.read<FavoriteProvider>().fetchFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAVORITES')),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          return provider.state.when(
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onSuccess: (favorites) {
              return RefreshIndicator(
                onRefresh: () => provider.fetchFavorites(),
                child: ListView.builder(
                  itemCount: favorites.length,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    final character = favorites[index];
                    return CharacterCard(
                      character: character,
                      onTap: () => _navigateToDetail(character.id),
                    );
                  },
                ),
              );
            },
            onError: (message) => ErrorStateWidget(
              message: message,
              onRetry: () => provider.fetchFavorites(),
            ),
            onEmpty: () =>
                const EmptyStateWidget(message: 'No favorite characters yet'),
          );
        },
      ),
    );
  }
}
