import 'package:rick_and_morty_app/src/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/src/features/character/domain/repositories/character_repository.dart';

class SearchCharacters {
  final CharacterRepository repository;

  SearchCharacters(this.repository);

  Future<List<Character>> execute(
    String query, {
    String? status,
    String? species,
    String? gender,
  }) {
    return repository.searchCharacters(
      query,
      status: status,
      species: species,
      gender: gender,
    );
  }
}
