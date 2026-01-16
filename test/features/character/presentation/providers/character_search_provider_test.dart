import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_app/src/core/state/ui_state.dart';
import 'package:rick_and_morty_app/src/features/character/domain/entities/character.dart';
import 'package:rick_and_morty_app/src/features/character/domain/usecases/search_characters.dart';
import 'package:rick_and_morty_app/src/features/character/presentation/providers/character_search_provider.dart';

class MockSearchCharacters extends Mock implements SearchCharacters {}

void main() {
  late CharacterSearchProvider provider;
  late MockSearchCharacters mockSearchCharacters;

  setUp(() {
    mockSearchCharacters = MockSearchCharacters();
    provider = CharacterSearchProvider(mockSearchCharacters);
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

  final tCharacters = [tCharacter1, tCharacter2];

  group('CharacterSearchProvider', () {
    test('initial state should be UiEmpty', () {
      // assert
      expect(provider.state, isA<UiEmpty>());
      expect(provider.results, isEmpty);
      expect(provider.hasActiveFilters, false);
    });

    test('should emit UiSuccess when search is successful', () async {
      // arrange
      when(
        () => mockSearchCharacters.execute(
          any(),
          status: any(named: 'status'),
          species: any(named: 'species'),
          gender: any(named: 'gender'),
        ),
      ).thenAnswer((_) async => tCharacters);

      // act
      await provider.search('Rick');

      // assert
      expect(provider.results, tCharacters);
      expect(provider.state, isA<UiSuccess<List<Character>>>());
    });

    test('should emit UiError when search fails', () async {
      // arrange
      when(
        () => mockSearchCharacters.execute(
          any(),
          status: any(named: 'status'),
          species: any(named: 'species'),
          gender: any(named: 'gender'),
        ),
      ).thenThrow(Exception('Network error'));

      // act
      await provider.search('Rick');

      // assert
      expect(provider.state, isA<UiError>());
      expect(provider.results, isEmpty);
    });

    test('should emit UiEmpty when search returns empty results', () async {
      // arrange
      when(
        () => mockSearchCharacters.execute(
          any(),
          status: any(named: 'status'),
          species: any(named: 'species'),
          gender: any(named: 'gender'),
        ),
      ).thenAnswer((_) async => []);

      // act
      await provider.search('NonExistentCharacter');

      // assert
      expect(provider.state, isA<UiEmpty>());
      expect(provider.results, isEmpty);
    });

    test('should apply filters correctly and trigger search', () async {
      // arrange
      when(
        () => mockSearchCharacters.execute(
          any(),
          status: 'alive',
          species: any(named: 'species'),
          gender: any(named: 'gender'),
        ),
      ).thenAnswer((_) async => [tCharacter1]);

      // act
      provider.setStatusFilter('alive');
      await Future.delayed(Duration.zero); // Wait for async operation

      // assert
      expect(provider.selectedStatus, 'alive');
      expect(provider.hasActiveFilters, true);
      verify(
        () => mockSearchCharacters.execute(
          any(),
          status: 'alive',
          species: any(named: 'species'),
          gender: any(named: 'gender'),
        ),
      ).called(1);
    });

    test('should clear filters and reset search', () async {
      // arrange
      provider.setStatusFilter('alive');
      provider.setSpeciesFilter('Human');
      provider.setGenderFilter('Male');

      when(
        () => mockSearchCharacters.execute(
          any(),
          status: any(named: 'status'),
          species: any(named: 'species'),
          gender: any(named: 'gender'),
        ),
      ).thenAnswer((_) async => tCharacters);

      // act
      provider.clearFilters();

      // assert
      expect(provider.selectedStatus, isNull);
      expect(provider.selectedSpecies, isNull);
      expect(provider.selectedGender, isNull);
      expect(provider.hasActiveFilters, false);
    });

    test('should clear state and results when clear is called', () {
      // arrange
      provider.search('Rick');

      // act
      provider.clear();

      // assert
      expect(provider.state, isA<UiEmpty>());
      expect(provider.results, isEmpty);
    });

    test('should pass all filters to search use case', () async {
      // arrange
      const query = 'Rick';
      const status = 'alive';
      const species = 'Human';
      const gender = 'Male';

      when(
        () => mockSearchCharacters.execute(
          query,
          status: status,
          species: species,
          gender: gender,
        ),
      ).thenAnswer((_) async => [tCharacter1]);

      provider.setStatusFilter(status);
      provider.setSpeciesFilter(species);
      provider.setGenderFilter(gender);

      // act
      await provider.search(query);

      // assert
      verify(
        () => mockSearchCharacters.execute(
          query,
          status: status,
          species: species,
          gender: gender,
        ),
      ).called(1);
    });
  });
}
