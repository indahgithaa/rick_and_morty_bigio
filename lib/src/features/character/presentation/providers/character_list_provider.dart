import 'package:flutter/foundation.dart';
import '../../../../core/state/ui_state.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/get_characters.dart';

class CharacterListProvider extends ChangeNotifier {
  final GetCharacters _getCharacters;

  CharacterListProvider(this._getCharacters);

  UiState<List<Character>> _state = const UiLoading();
  UiState<List<Character>> get state => _state;

  int _currentPage = 1;
  List<Character> _characters = [];
  bool _hasMore = true;
  bool _isLoadingMore = false;

  List<Character> get characters => _characters;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> fetchCharacters({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _characters = [];
      _hasMore = true;
      _state = const UiLoading();
      notifyListeners();
    }

    if (!_hasMore) return;

    try {
      final result = await _getCharacters.execute(_currentPage);

      if (result.isEmpty) {
        _hasMore = false;
        if (_characters.isEmpty) {
          _state = const UiEmpty();
        }
      } else {
        _characters.addAll(result);
        _currentPage++;
        _state = UiSuccess(_characters);
      }
    } catch (e) {
      if (_characters.isEmpty) {
        _state = UiError(e.toString());
      } else {
        _hasMore = false;
      }
    }

    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _getCharacters.execute(_currentPage);

      if (result.isEmpty) {
        _hasMore = false;
      } else {
        _characters.addAll(result);
        _currentPage++;
        _state = UiSuccess(_characters);
      }
    } catch (e) {
      _hasMore = false;
    }

    _isLoadingMore = false;
    notifyListeners();
  }
}
