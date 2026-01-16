import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/src/core/state/ui_state.dart';
import 'package:rick_and_morty_app/src/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/src/features/character/domain/usecases/add_favorite_character.dart';
import 'package:rick_and_morty_app/src/features/character/domain/usecases/check_is_favorite.dart';
import 'package:rick_and_morty_app/src/features/character/domain/usecases/get_favorite_characters.dart';
import 'package:rick_and_morty_app/src/features/character/domain/usecases/remove_favorite_character.dart';
import 'package:rick_and_morty_app/src/features/character/presentation/providers/favorite_provider.dart';

class MockAddFavoriteCharacter extends Mock implements AddFavoriteCharacter {}

class MockRemoveFavoriteCharacter extends Mock
    implements RemoveFavoriteCharacter {}

class MockGetFavoriteCharacters extends Mock implements GetFavoriteCharacters {}

class MockCheckIsFavorite extends Mock implements CheckIsFavorite {}

class FakeCharacter extends Fake implements Character {}

void main() {
  late FavoriteProvider provider;
  late MockAddFavoriteCharacter mockAddFavorite;
  late MockRemoveFavoriteCharacter mockRemoveFavorite;
  late MockGetFavoriteCharacters mockGetFavorites;
  late MockCheckIsFavorite mockCheckIsFavorite;

  setUpAll(() {
    registerFallbackValue(FakeCharacter());
  });

  setUp(() {
    mockAddFavorite = MockAddFavoriteCharacter();
    mockRemoveFavorite = MockRemoveFavoriteCharacter();
    mockGetFavorites = MockGetFavoriteCharacters();
    mockCheckIsFavorite = MockCheckIsFavorite();
    provider = FavoriteProvider(
      mockAddFavorite,
      mockRemoveFavorite,
      mockGetFavorites,
      mockCheckIsFavorite,
    );
  });

  final tCharacter1 = Character(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    origin: const Location(name: 'Earth (C-137)', url: ''),
    location: const Location(name: 'Citadel of Ricks', url: ''),
    episode: [],
    url: '',
    created: DateTime.now(),
  );

  final tCharacter2 = Character(
    id: 2,
    name: 'Morty Smith',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    origin: const Location(name: 'unknown', url: ''),
    location: const Location(name: 'Citadel of Ricks', url: ''),
    episode: [],
    url: '',
    created: DateTime.now(),
  );

  final tFavorites = [tCharacter1, tCharacter2];

  group('FavoriteProvider - Fetch Favorites', () {
    test('should fetch favorites successfully', () async {
      // arrange
      when(
        () => mockGetFavorites.execute(),
      ).thenAnswer((_) async => tFavorites);

      // act
      await provider.fetchFavorites();

      // assert
      expect(provider.favorites, tFavorites);
      expect(provider.state, isA<UiSuccess<List<Character>>>());
      verify(() => mockGetFavorites.execute()).called(1);
    });

    test('should emit UiEmpty when no favorites exist', () async {
      // arrange
      when(() => mockGetFavorites.execute()).thenAnswer((_) async => []);

      // act
      await provider.fetchFavorites();

      // assert
      expect(provider.favorites, isEmpty);
      expect(provider.state, isA<UiEmpty>());
    });

    test('should emit UiError when fetch fails', () async {
      // arrange
      when(
        () => mockGetFavorites.execute(),
      ).thenThrow(Exception('Database error'));

      // act
      await provider.fetchFavorites();

      // assert
      expect(provider.state, isA<UiError>());
    });

    test('should update favorite status map after fetch', () async {
      // arrange
      when(
        () => mockGetFavorites.execute(),
      ).thenAnswer((_) async => tFavorites);

      // act
      await provider.fetchFavorites();

      // assert
      expect(provider.getFavoriteStatus(1), true);
      expect(provider.getFavoriteStatus(2), true);
      expect(provider.getFavoriteStatus(999), false);
    });
  });

  group('FavoriteProvider - Toggle Favorite', () {
    test('should add character to favorites when not favorite', () async {
      // arrange
      when(
        () => mockCheckIsFavorite.execute(tCharacter1.id),
      ).thenAnswer((_) async => false);
      when(() => mockAddFavorite.execute(any())).thenAnswer((_) async => {});
      when(() => mockGetFavorites.execute()).thenAnswer((_) async => []);

      await provider.fetchFavorites();

      // act
      await provider.toggleFavorite(tCharacter1);

      // assert
      verify(() => mockAddFavorite.execute(tCharacter1)).called(1);
      expect(provider.getFavoriteStatus(tCharacter1.id), true);
    });

    test(
      'should remove character from favorites when already favorite',
      () async {
        // arrange
        when(
          () => mockGetFavorites.execute(),
        ).thenAnswer((_) async => [tCharacter1]);
        await provider.fetchFavorites();

        when(
          () => mockCheckIsFavorite.execute(tCharacter1.id),
        ).thenAnswer((_) async => true);
        when(
          () => mockRemoveFavorite.execute(tCharacter1.id),
        ).thenAnswer((_) async => {});

        // act
        await provider.toggleFavorite(tCharacter1);

        // assert
        verify(() => mockRemoveFavorite.execute(tCharacter1.id)).called(1);
        expect(provider.getFavoriteStatus(tCharacter1.id), false);
      },
    );

    test('should update state to empty after removing last favorite', () async {
      // arrange
      when(
        () => mockGetFavorites.execute(),
      ).thenAnswer((_) async => [tCharacter1]);
      await provider.fetchFavorites();

      when(
        () => mockCheckIsFavorite.execute(tCharacter1.id),
      ).thenAnswer((_) async => true);
      when(
        () => mockRemoveFavorite.execute(tCharacter1.id),
      ).thenAnswer((_) async => {});

      // act
      await provider.toggleFavorite(tCharacter1);

      // assert
      expect(provider.state, isA<UiEmpty>());
      expect(provider.favorites, isEmpty);
    });
  });

  group('FavoriteProvider - Favorite Status', () {
    test('should check if character is favorite', () async {
      // arrange
      when(() => mockCheckIsFavorite.execute(1)).thenAnswer((_) async => true);

      // act
      final result = await provider.isFavorite(1);

      // assert
      expect(result, true);
      verify(() => mockCheckIsFavorite.execute(1)).called(1);
    });

    test('should cache favorite status after check', () async {
      // arrange
      when(() => mockCheckIsFavorite.execute(1)).thenAnswer((_) async => true);

      // act
      await provider.isFavorite(1);
      final result = await provider.isFavorite(1); // Second call

      // assert
      expect(result, true);
      verify(
        () => mockCheckIsFavorite.execute(1),
      ).called(1); // Only called once (cached)
    });

    test('should return false for non-favorite character', () {
      // act
      final status = provider.getFavoriteStatus(999);

      // assert
      expect(status, false);
    });

    test('should return false when check fails', () async {
      // arrange
      when(
        () => mockCheckIsFavorite.execute(any()),
      ).thenThrow(Exception('Database error'));

      // act
      final result = await provider.isFavorite(1);

      // assert
      expect(result, false);
    });
  });
}
