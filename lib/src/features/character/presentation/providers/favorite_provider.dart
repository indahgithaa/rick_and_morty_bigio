import 'package:flutter/foundation.dart';
import '../../../../core/state/ui_state.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/add_favorite_character.dart';
import '../../domain/usecases/check_is_favorite.dart';
import '../../domain/usecases/get_favorite_characters.dart';
import '../../domain/usecases/remove_favorite_character.dart';

class FavoriteProvider extends ChangeNotifier {
  final AddFavoriteCharacter _addFavorite;
  final RemoveFavoriteCharacter _removeFavorite;
  final GetFavoriteCharacters _getFavorites;
  final CheckIsFavorite _checkIsFavorite;

  FavoriteProvider(
    this._addFavorite,
    this._removeFavorite,
    this._getFavorites,
    this._checkIsFavorite,
  );

  UiState<List<Character>> _state = const UiLoading();
  UiState<List<Character>> get state => _state;

  List<Character> _favorites = [];
  List<Character> get favorites => _favorites;

  final Map<int, bool> _favoriteStatus = {};

  Future<void> fetchFavorites() async {
    _state = const UiLoading();
    notifyListeners();

    try {
      final result = await _getFavorites.execute();
      _favorites = result;
      _state = result.isEmpty ? const UiEmpty() : UiSuccess(result);

      _favoriteStatus.clear();
      for (var character in result) {
        _favoriteStatus[character.id] = true;
      }
    } catch (e) {
      _state = UiError(e.toString());
    }

    notifyListeners();
  }

  Future<bool> isFavorite(int id) async {
    if (_favoriteStatus.containsKey(id)) {
      return _favoriteStatus[id]!;
    }

    try {
      final result = await _checkIsFavorite.execute(id);
      _favoriteStatus[id] = result;
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleFavorite(Character character) async {
    try {
      final currentStatus = await isFavorite(character.id);

      if (currentStatus) {
        await _removeFavorite.execute(character.id);
        _favorites.removeWhere((c) => c.id == character.id);
        _favoriteStatus[character.id] = false;
      } else {
        await _addFavorite.execute(character);
        _favorites.add(character);
        _favoriteStatus[character.id] = true;
      }

      _state = _favorites.isEmpty ? const UiEmpty() : UiSuccess(_favorites);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  bool getFavoriteStatus(int id) {
    return _favoriteStatus[id] ?? false;
  }
}
