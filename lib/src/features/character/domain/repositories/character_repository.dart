import '../entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters(int page);
  Future<Character> getCharacterDetail(int id);
  Future<List<Character>> searchCharacters(
    String query, {
    String? status,
    String? species,
    String? gender,
  });
  Future<List<Character>> filterByLocation(String location);
  Future<List<Character>> filterByEpisode(int episodeId);
  Future<void> addFavorite(Character character);
  Future<void> removeFavorite(int id);
  Future<List<Character>> getFavorites();
  Future<bool> isFavorite(int id);
}
