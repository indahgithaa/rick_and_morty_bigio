import 'package:rick_and_morty_app/src/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/src/features/character/domain/repositories/character_repository.dart';

class AddFavoriteCharacter {
  final CharacterRepository repository;

  AddFavoriteCharacter(this.repository);

  Future<void> execute(Character character) {
    return repository.addFavorite(character);
  }
}
