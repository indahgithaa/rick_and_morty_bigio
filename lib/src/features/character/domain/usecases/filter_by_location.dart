import 'package:rick_and_morty_app/src/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/src/features/character/domain/repositories/character_repository.dart';

class FilterByLocation {
  final CharacterRepository repository;

  FilterByLocation(this.repository);

  Future<List<Character>> execute(String location) {
    return repository.filterByLocation(location);
  }
}
