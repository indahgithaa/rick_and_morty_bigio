import '../../domain/usecases/domain/entities/character.dart';
import '../../domain/usecases/domain/repositories/character_repository.dart';
import '../datasources/character_local_datasource.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/character_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Character>> getCharacters(int page) async {
    final models = await remoteDataSource.getCharacters(page);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Character> getCharacterDetail(int id) async {
    final model = await remoteDataSource.getCharacterDetail(id);
    return model.toEntity();
  }

  @override
  Future<List<Character>> searchCharacters(
    String query, {
    String? status,
    String? species,
    String? gender,
  }) async {
    try {
      final characterModels = await remoteDataSource.searchCharacters(
        query,
        status: status,
        species: species,
        gender: gender,
      );
      return characterModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Character>> filterByLocation(String location) async {
    final models = await remoteDataSource.filterByLocation(location);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Character>> filterByEpisode(int episodeId) async {
    final models = await remoteDataSource.filterByEpisode(episodeId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addFavorite(Character character) async {
    final model = CharacterModel(
      id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      type: character.type,
      gender: character.gender,
      image: character.image,
      origin: LocationModel(
        name: character.origin.name,
        url: character.origin.url,
      ),
      location: LocationModel(
        name: character.location.name,
        url: character.location.url,
      ),
      episode: character.episode,
      url: character.url,
      created: character.created,
    );

    await localDataSource.addFavorite(model);
  }

  @override
  Future<void> removeFavorite(int id) async {
    await localDataSource.removeFavorite(id);
  }

  @override
  Future<List<Character>> getFavorites() async {
    final models = await localDataSource.getFavorites();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> isFavorite(int id) async {
    return await localDataSource.isFavorite(id);
  }
}
