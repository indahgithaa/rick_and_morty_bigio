import '../../../../core/database/favorite_dao.dart';
import '../models/character_model.dart';

abstract class CharacterLocalDataSource {
  Future<void> addFavorite(CharacterModel character);
  Future<void> removeFavorite(int id);
  Future<List<CharacterModel>> getFavorites();
  Future<bool> isFavorite(int id);
}

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  final FavoriteDao favoriteDao;

  CharacterLocalDataSourceImpl(this.favoriteDao);

  @override
  Future<void> addFavorite(CharacterModel character) async {
    await favoriteDao.insert(character.toMap());
  }

  @override
  Future<void> removeFavorite(int id) async {
    await favoriteDao.delete(id);
  }

  @override
  Future<List<CharacterModel>> getFavorites() async {
    final maps = await favoriteDao.getAll();
    return maps.map((map) => CharacterModel.fromMap(map)).toList();
  }

  @override
  Future<bool> isFavorite(int id) async {
    return await favoriteDao.isFavorite(id);
  }
}
