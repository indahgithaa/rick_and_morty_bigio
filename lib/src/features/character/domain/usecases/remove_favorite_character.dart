import 'package:rick_and_morty_app/src/features/character/domain/repositories/character_repository.dart';

class RemoveFavoriteCharacter {
  final CharacterRepository repository;

  RemoveFavoriteCharacter(this.repository);

  Future<void> execute(int id) {
    return repository.removeFavorite(id);
  }
}
