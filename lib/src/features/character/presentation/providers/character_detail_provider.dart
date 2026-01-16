import 'package:flutter/foundation.dart';
import '../../../../core/state/ui_state.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/get_character_detail.dart';

class CharacterDetailProvider extends ChangeNotifier {
  final GetCharacterDetail _getCharacterDetail;

  CharacterDetailProvider(this._getCharacterDetail);

  UiState<Character> _state = const UiLoading();
  UiState<Character> get state => _state;

  Character? _character;
  Character? get character => _character;

  Future<void> fetchCharacterDetail(int id) async {
    _state = const UiLoading();
    notifyListeners();

    try {
      final result = await _getCharacterDetail.execute(id);
      _character = result;
      _state = UiSuccess(result);
    } catch (e) {
      _state = UiError(e.toString());
    }

    notifyListeners();
  }

  void reset() {
    _state = const UiLoading();
    _character = null;
    notifyListeners();
  }
}
