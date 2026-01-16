import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/extensions/ui_state_extension.dart';
import '../../../../core/router/route_names.dart';
import '../providers/character_list_provider.dart';
import '../widgets/character_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/loading_shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterListProvider>().fetchCharacters(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<CharacterListProvider>().loadMore();
    }
  }

  void _navigateToDetail(int characterId) {
    Navigator.pushNamed(
      context,
      RouteNames.characterDetail,
      arguments: characterId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RICK & MORTY'), centerTitle: true),
      body: Consumer<CharacterListProvider>(
        builder: (context, provider, _) {
          return provider.state.when(
            onLoading: () => const LoadingShimmer(),
            onSuccess: (characters) {
              return RefreshIndicator(
                onRefresh: () => provider.fetchCharacters(refresh: true),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: characters.length + (provider.hasMore ? 1 : 0),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    if (index == characters.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final character = characters[index];
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
              onRetry: () => provider.fetchCharacters(refresh: true),
            ),
            onEmpty: () =>
                const EmptyStateWidget(message: 'No characters found'),
          );
        },
      ),
    );
  }
}
