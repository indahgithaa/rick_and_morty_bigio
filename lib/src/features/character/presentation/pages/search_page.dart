import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/character_search_provider.dart';
import '../widgets/search/search_bar_widget.dart';
import '../widgets/search/active_filters_widget.dart';
import '../widgets/search/search_results_widget.dart';
import '../widgets/search/filter_bottom_sheet.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isNotEmpty) {
      context.read<CharacterSearchProvider>().search(trimmedQuery);
    } else {
      context.read<CharacterSearchProvider>().clear();
    }
  }

  void _showFilterBottomSheet() {
    _searchFocus.unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
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
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('SEARCH CHARACTERS'), centerTitle: true),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            focusNode: _searchFocus,
            onChanged: (value) {
              setState(() {});
              Future.delayed(const Duration(milliseconds: 500), () {
                if (_searchController.text == value) {
                  _onSearch(value);
                }
              });
            },
            onClear: () {
              _searchController.clear();
              context.read<CharacterSearchProvider>().clear();
              setState(() {});
            },
            onFilterTap: _showFilterBottomSheet,
          ),
          const ActiveFiltersWidget(),
          Expanded(
            child: SearchResultsWidget(
              searchQuery: _searchController.text,
              onCharacterTap: _navigateToDetail,
              onRetry: () => _onSearch(_searchController.text),
            ),
          ),
        ],
      ),
    );
  }
}
