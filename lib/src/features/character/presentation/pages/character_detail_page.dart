import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/src/core/extensions/ui_state_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/character_detail_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/error_state_widget.dart';

class CharacterDetailPage extends StatefulWidget {
  final int characterId;

  const CharacterDetailPage({super.key, required this.characterId});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterDetailProvider>().fetchCharacterDetail(
        widget.characterId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CharacterDetailProvider>(
        builder: (context, provider, _) {
          return provider.state.when(
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onSuccess: (character) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'character-${character.id}',
                        child: Image.network(
                          character.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surface,
                            child: const Icon(Icons.person, size: 100),
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Consumer<FavoriteProvider>(
                        builder: (context, favProvider, _) {
                          return FutureBuilder<bool>(
                            future: favProvider.isFavorite(character.id),
                            builder: (context, snapshot) {
                              final isFav = snapshot.data ?? false;
                              return IconButton(
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.red : null,
                                ),
                                onPressed: () {
                                  favProvider.toggleFavorite(character);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            character.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _StatusChip(status: character.status),
                              const SizedBox(width: 8),
                              Text(
                                '${character.species} • ${character.gender}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _InfoSection(
                            title: 'Origin',
                            content: character.origin.name,
                            icon: Icons.public,
                          ),
                          const SizedBox(height: 16),
                          _InfoSection(
                            title: 'Last known location',
                            content: character.location.name,
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 16),
                          _InfoSection(
                            title: 'Episodes',
                            content: '${character.episode.length} episodes',
                            icon: Icons.tv,
                          ),
                          if (character.type.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _InfoSection(
                              title: 'Type',
                              content: character.type,
                              icon: Icons.category,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            onError: (message) => ErrorStateWidget(
              message: message,
              onRetry: () => context
                  .read<CharacterDetailProvider>()
                  .fetchCharacterDetail(widget.characterId),
            ),
            onEmpty: () => const Center(child: Text('No data')),
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'alive':
        color = Colors.green;
        break;
      case 'dead':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _InfoSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
