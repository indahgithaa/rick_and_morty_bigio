import 'package:flutter/foundation.dart';
import '../../../../core/state/ui_state.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/search_characters.dart';

class CharacterSearchProvider extends ChangeNotifier {
  final SearchCharacters _searchCharacters;

  CharacterSearchProvider(this._searchCharacters);

  UiState<List<Character>> _state = const UiEmpty();
  UiState<List<Character>> get state => _state;

  List<Character> _results = [];
  List<Character> get results => _results;

  String? _selectedStatus;
  String? _selectedSpecies;
  String? _selectedGender;

  String? get selectedStatus => _selectedStatus;
  String? get selectedSpecies => _selectedSpecies;
  String? get selectedGender => _selectedGender;

  String _lastQuery = '';

  bool get hasActiveFilters =>
      _selectedStatus != null ||
      _selectedSpecies != null ||
      _selectedGender != null;

  Future<void> search(String query) async {
    _lastQuery = query.trim();

    if (_lastQuery.isEmpty && !hasActiveFilters) {
      clear();
      return;
    }

    _state = const UiLoading();
    notifyListeners();

    try {
      final characters = await _searchCharacters.execute(
        _lastQuery,
        status: _selectedStatus,
        species: _selectedSpecies,
        gender: _selectedGender,
      );

      _results = characters;
      _state = characters.isEmpty ? const UiEmpty() : UiSuccess(characters);
      notifyListeners();
    } catch (e) {
      _state = UiError(e.toString());
      _results = [];
      notifyListeners();
    }
  }

  void setStatusFilter(String? status) {
    _selectedStatus = status;
    if (_lastQuery.isNotEmpty || hasActiveFilters) {
      search(_lastQuery);
    } else {
      clear();
    }
    notifyListeners();
  }

  void setSpeciesFilter(String? species) {
    _selectedSpecies = species;
    if (_lastQuery.isNotEmpty || hasActiveFilters) {
      search(_lastQuery);
    } else {
      clear();
    }
    notifyListeners();
  }

  void setGenderFilter(String? gender) {
    _selectedGender = gender;
    if (_lastQuery.isNotEmpty || hasActiveFilters) {
      search(_lastQuery);
    } else {
      clear();
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedStatus = null;
    _selectedSpecies = null;
    _selectedGender = null;
    notifyListeners();
    if (_lastQuery.isNotEmpty) {
      search(_lastQuery);
    } else {
      clear();
    }
  }

  void clear() {
    _state = const UiEmpty();
    _results = [];
    _lastQuery = '';
    notifyListeners();
  }
}
