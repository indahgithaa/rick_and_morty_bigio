import 'package:rick_and_morty_app/src/features/character/domain/repositories/character_repository.dart';

class CheckIsFavorite {
  final CharacterRepository repository;

  CheckIsFavorite(this.repository);

  Future<bool> execute(int id) {
    return repository.isFavorite(id);
  }
}
