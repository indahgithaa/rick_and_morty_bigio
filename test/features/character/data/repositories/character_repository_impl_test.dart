import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/src/features/character/data/datasources/character_local_datasource.dart';
import 'package:rick_and_morty_app/src/features/character/data/datasources/character_remote_datasource.dart';
import 'package:rick_and_morty_app/src/features/character/data/models/character_model.dart';
import 'package:rick_and_morty_app/src/features/character/data/repositories/character_repository_impl.dart';
import 'package:rick_and_morty_app/src/features/character/domain/entities/character.dart';

class MockCharacterRemoteDataSource extends Mock
    implements CharacterRemoteDataSource {}

class MockCharacterLocalDataSource extends Mock
    implements CharacterLocalDataSource {}

class FakeCharacterModel extends Fake implements CharacterModel {}

void main() {
  late CharacterRepositoryImpl repository;
  late MockCharacterRemoteDataSource mockRemoteDataSource;
  late MockCharacterLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakeCharacterModel());
  });

  setUp(() {
    mockRemoteDataSource = MockCharacterRemoteDataSource();
    mockLocalDataSource = MockCharacterLocalDataSource();
    repository = CharacterRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tCharacterModel1 = CharacterModel(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    origin: LocationModel(name: 'Earth (C-137)', url: ''),
    location: LocationModel(name: 'Citadel of Ricks', url: ''),
    episode: [],
    url: '',
    created: DateTime.now(),
  );

  final tCharacterModel2 = CharacterModel(
    id: 2,
    name: 'Morty Smith',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    origin: LocationModel(name: 'unknown', url: ''),
    location: LocationModel(name: 'Citadel of Ricks', url: ''),
    episode: [],
    url: '',
    created: DateTime.now(),
  );

  final tDeadCharacter = CharacterModel(
    id: 3,
    name: 'Dead Character',
    status: 'Dead',
    species: 'Alien',
    type: '',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/3.jpeg',
    origin: LocationModel(name: 'unknown', url: ''),
    location: LocationModel(name: 'unknown', url: ''),
    episode: [],
    url: '',
    created: DateTime.now(),
  );

  group('CharacterRepository - Get Characters', () {
    test('should return list of characters from remote data source', () async {
      // arrange
      final tCharacterModels = [tCharacterModel1, tCharacterModel2];
      when(
        () => mockRemoteDataSource.getCharacters(any()),
      ).thenAnswer((_) async => tCharacterModels);

      // act
      final result = await repository.getCharacters(1);

      // assert
      expect(result, isA<List<Character>>());
      expect(result.length, 2);
      expect(result.first.name, 'Rick Sanchez');
      verify(() => mockRemoteDataSource.getCharacters(1)).called(1);
    });

    test('should throw exception when remote data source fails', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getCharacters(any()),
      ).thenThrow(Exception('Network error'));

      // act & assert
      expect(() => repository.getCharacters(1), throwsException);
    });
  });

  group('CharacterRepository - Search Characters', () {
    test('should return characters matching search query', () async {
      // arrange
      when(
        () => mockRemoteDataSource.searchCharacters(
          'Rick',
          status: null,
          species: null,
          gender: null,
        ),
      ).thenAnswer((_) async => [tCharacterModel1]);

      // act
      final result = await repository.searchCharacters('Rick');

      // assert
      expect(result, isA<List<Character>>());
      expect(result.length, 1);
      expect(result.first.name, 'Rick Sanchez');
      verify(
        () => mockRemoteDataSource.searchCharacters(
          'Rick',
          status: null,
          species: null,
          gender: null,
        ),
      ).called(1);
    });

    test('should pass filters to remote data source', () async {
      // arrange
      const query = 'Rick';
      const status = 'alive';
      const species = 'Human';
      const gender = 'Male';

      when(
        () => mockRemoteDataSource.searchCharacters(
          query,
          status: status,
          species: species,
          gender: gender,
        ),
      ).thenAnswer((_) async => [tCharacterModel1]);

      // act
      final result = await repository.searchCharacters(
        query,
        status: status,
        species: species,
        gender: gender,
      );

      // assert
      expect(result.length, 1);
      verify(
        () => mockRemoteDataSource.searchCharacters(
          query,
          status: status,
          species: species,
          gender: gender,
        ),
      ).called(1);
    });

    test('should return empty list when no characters match', () async {
      // arrange
      when(
        () => mockRemoteDataSource.searchCharacters(
          any(),
          status: any(named: 'status'),
          species: any(named: 'species'),
          gender: any(named: 'gender'),
        ),
      ).thenAnswer((_) async => []);

      // act
      final result = await repository.searchCharacters('NonExistent');

      // assert
      expect(result, isEmpty);
    });

    test('should filter by status correctly', () async {
      // arrange
      when(
        () => mockRemoteDataSource.searchCharacters(
          '',
          status: 'dead',
          species: null,
          gender: null,
        ),
      ).thenAnswer((_) async => [tDeadCharacter]);

      // act
      final result = await repository.searchCharacters('', status: 'dead');

      // assert
      expect(result.length, 1);
      expect(result.first.status, 'Dead');
    });
  });

  group('CharacterRepository - Get Character Detail', () {
    test('should return character detail from remote data source', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getCharacterDetail(1),
      ).thenAnswer((_) async => tCharacterModel1);

      // act
      final result = await repository.getCharacterDetail(1);

      // assert
      expect(result, isA<Character>());
      expect(result.id, 1);
      expect(result.name, 'Rick Sanchez');
      verify(() => mockRemoteDataSource.getCharacterDetail(1)).called(1);
    });

    test('should throw exception when character not found', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getCharacterDetail(any()),
      ).thenThrow(Exception('Character not found'));

      // act & assert
      expect(() => repository.getCharacterDetail(999), throwsException);
    });
  });

  group('CharacterRepository - Favorites', () {
    final tCharacter = tCharacterModel1.toEntity();

    test('should add character to favorites', () async {
      // arrange
      when(
        () => mockLocalDataSource.addFavorite(any()),
      ).thenAnswer((_) async => {});

      // act
      await repository.addFavorite(tCharacter);

      // assert
      verify(() => mockLocalDataSource.addFavorite(any())).called(1);
    });

    test('should remove character from favorites', () async {
      // arrange
      when(
        () => mockLocalDataSource.removeFavorite(any()),
      ).thenAnswer((_) async => {});

      // act
      await repository.removeFavorite(1);

      // assert
      verify(() => mockLocalDataSource.removeFavorite(1)).called(1);
    });

    test('should get all favorites from local data source', () async {
      // arrange
      final tCharacterModels = [tCharacterModel1, tCharacterModel2];
      when(
        () => mockLocalDataSource.getFavorites(),
      ).thenAnswer((_) async => tCharacterModels);

      // act
      final result = await repository.getFavorites();

      // assert
      expect(result, isA<List<Character>>());
      expect(result.length, 2);
      verify(() => mockLocalDataSource.getFavorites()).called(1);
    });

    test('should check if character is favorite', () async {
      // arrange
      when(
        () => mockLocalDataSource.isFavorite(1),
      ).thenAnswer((_) async => true);

      // act
      final result = await repository.isFavorite(1);

      // assert
      expect(result, true);
      verify(() => mockLocalDataSource.isFavorite(1)).called(1);
    });

    test('should return false when character is not favorite', () async {
      // arrange
      when(
        () => mockLocalDataSource.isFavorite(999),
      ).thenAnswer((_) async => false);

      // act
      final result = await repository.isFavorite(999);

      // assert
      expect(result, false);
    });
  });

  group('CharacterRepository - Edge Cases', () {
    test('should handle empty results from remote source', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getCharacters(any()),
      ).thenAnswer((_) async => []);

      // act
      final result = await repository.getCharacters(100);

      // assert
      expect(result, isEmpty);
    });

    test('should handle network timeout', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getCharacters(any()),
      ).thenThrow(Exception('Connection timeout'));

      // act & assert
      expect(() => repository.getCharacters(1), throwsException);
    });

    test('should handle malformed data', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getCharacters(any()),
      ).thenThrow(Exception('Invalid JSON format'));

      // act & assert
      expect(() => repository.getCharacters(1), throwsException);
    });
  });
}
