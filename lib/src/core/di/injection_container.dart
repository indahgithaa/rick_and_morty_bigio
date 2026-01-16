import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rick_and_morty_app/src/features/character/data/datasources/character_remote_datasource.dart';
import '../database/favorite_dao.dart';
import '../network/dio_client.dart';
import '../../features/character/data/datasources/character_local_datasource.dart';
import '../../features/character/data/repositories/character_repository_impl.dart';
import '../../features/character/domain/repositories/character_repository.dart';
import '../../features/character/domain/usecases/add_favorite_character.dart';
import '../../features/character/domain/usecases/check_is_favorite.dart';
import '../../features/character/domain/usecases/get_character_detail.dart';
import '../../features/character/domain/usecases/get_characters.dart';
import '../../features/character/domain/usecases/get_favorite_characters.dart';
import '../../features/character/domain/usecases/remove_favorite_character.dart';
import '../../features/character/domain/usecases/search_characters.dart';
import '../../features/character/presentation/providers/character_detail_provider.dart';
import '../../features/character/presentation/providers/character_list_provider.dart';
import '../../features/character/presentation/providers/character_search_provider.dart';
import '../../features/character/presentation/providers/favorite_provider.dart';

class InjectionContainer {
  static List<SingleChildWidget> getProviders() {
    final dio = DioClient.create();
    final favoriteDao = FavoriteDao();
    final remoteDataSource = CharacterRemoteDataSourceImpl(dio);
    final localDataSource = CharacterLocalDataSourceImpl(favoriteDao);

    final CharacterRepository repository = CharacterRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    final getCharacters = GetCharacters(repository);
    final getCharacterDetail = GetCharacterDetail(repository);
    final searchCharacters = SearchCharacters(repository);
    final addFavorite = AddFavoriteCharacter(repository);
    final removeFavorite = RemoveFavoriteCharacter(repository);
    final getFavorites = GetFavoriteCharacters(repository);
    final checkIsFavorite = CheckIsFavorite(repository);

    return [
      ChangeNotifierProvider(
        create: (_) => CharacterListProvider(getCharacters),
      ),
      ChangeNotifierProvider(
        create: (_) => CharacterDetailProvider(getCharacterDetail),
      ),
      ChangeNotifierProvider(
        create: (_) => CharacterSearchProvider(searchCharacters),
      ),
      ChangeNotifierProvider(
        create: (_) => FavoriteProvider(
          addFavorite,
          removeFavorite,
          getFavorites,
          checkIsFavorite,
        ),
      ),
    ];
  }
}
