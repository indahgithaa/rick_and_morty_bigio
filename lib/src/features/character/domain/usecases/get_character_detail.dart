import 'package:rick_and_morty_app/src/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/src/features/character/domain/repositories/character_repository.dart';

class GetCharacterDetail {
  final CharacterRepository repository;

  GetCharacterDetail(this.repository);

  Future<Character> execute(int id) {
    return repository.getCharacterDetail(id);
  }
}
