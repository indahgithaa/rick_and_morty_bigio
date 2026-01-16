import 'package:rick_and_morty_app/src/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/src/features/character/domain/repositories/character_repository.dart';

class GetFavoriteCharacters {
  final CharacterRepository repository;

  GetFavoriteCharacters(this.repository);

  Future<List<Character>> execute() {
    return repository.getFavorites();
  }
}
