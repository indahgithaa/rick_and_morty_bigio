# Unit Testing Documentation

This project includes comprehensive unit tests for critical components of the Rick and Morty app.

## Test Coverage

### 1. CharacterSearchProvider Tests
**File:** `test/features/character/presentation/providers/character_search_provider_test.dart`

**Test Cases (7 tests):**
- ✅ Initial state validation
- ✅ Successful search with results  
- ✅ Error handling during search
- ✅ Empty results handling
- ✅ Status filter application
- ✅ Clear filters functionality
- ✅ Multiple filters combination

**What's Tested:**
- Provider state management (UiLoading, UiSuccess, UiError, UiEmpty)
- Search functionality with query
- Filter application (status, species, gender)
- Filter clearing and resetting
- Integration with SearchCharacters use case

---

### 2. FavoriteProvider Tests
**File:** `test/features/character/presentation/providers/favorite_provider_test.dart`

**Test Cases (12 tests):**

**Fetch Favorites Group:**
- ✅ Fetch favorites successfully
- ✅ Handle empty favorites
- ✅ Error handling during fetch
- ✅ Update favorite status map

**Toggle Favorite Group:**
- ✅ Add character to favorites
- ✅ Remove character from favorites
- ✅ Update state after removing last favorite

**Favorite Status Group:**
- ✅ Check favorite status
- ✅ Cache favorite status
- ✅ Return false for non-favorite
- ✅ Handle check failure
- ✅ Get status from cache

**What's Tested:**
- Favorite management (add, remove, toggle)
- State management for favorites
- Caching mechanism for favorite status
- Integration with favorite use cases
- Error handling

---

### 3. CharacterRepositoryImpl Tests
**File:** `test/features/character/data/repositories/character_repository_impl_test.dart`

**Test Cases (16 tests):**

**Get Characters Group:**
- ✅ Return list from remote source
- ✅ Handle remote source failure

**Search Characters Group:**
- ✅ Search with query
- ✅ Pass filters to datasource
- ✅ Handle empty results
- ✅ Filter by status

**Get Character Detail Group:**
- ✅ Return character detail
- ✅ Handle not found error

**Favorites Group:**
- ✅ Add to favorites
- ✅ Remove from favorites
- ✅ Get all favorites
- ✅ Check favorite status
- ✅ Return false for non-favorite

**Edge Cases Group:**
- ✅ Handle empty results
- ✅ Handle network timeout
- ✅ Handle malformed data

**What's Tested:**
- Repository pattern implementation
- Data source coordination
- Entity/Model conversion
- Error handling and edge cases
- Favorite persistence operations

---

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/features/character/presentation/providers/character_search_provider_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Report
```bash
# Install lcov first (if not installed)
# On Ubuntu/Linux: sudo apt-get install lcov
# On macOS: brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report (on macOS)
open coverage/html/index.html

# Open report (on Linux)
xdg-open coverage/html/index.html

# Open report (on Windows)
start coverage/html/index.html
```

---

## Test Structure

All tests follow the **AAA pattern**:
- **Arrange**: Setup test data and mocks
- **Act**: Execute the function being tested
- **Assert**: Verify the results

Example:
```dart
test('should fetch favorites successfully', () async {
  // arrange
  when(() => mockGetFavorites.execute())
      .thenAnswer((_) async => tFavorites);

  // act
  await provider.fetchFavorites();

  // assert
  expect(provider.favorites, tFavorites);
  expect(provider.state, isA<UiSuccess<List<Character>>>());
  verify(() => mockGetFavorites.execute()).called(1);
});
```

---

## Mocking Strategy

We use **Mocktail** for mocking dependencies:
- Clean syntax similar to Mockito
- Better null safety support
- No code generation required

Example mock setup:
```dart
class MockSearchCharacters extends Mock implements SearchCharacters {}

late MockSearchCharacters mockSearchCharacters;

setUp(() {
  mockSearchCharacters = MockSearchCharacters();
  provider = CharacterSearchProvider(mockSearchCharacters);
});
```

---

## Key Testing Concepts Used

1. **State Management Testing**: Verify provider states (Loading, Success, Error, Empty)
2. **Mock Verification**: Ensure methods are called with correct parameters
3. **Async Testing**: Handle async operations with `async/await`
4. **Edge Case Testing**: Test error conditions, empty data, network failures
5. **Integration Testing**: Test interaction between layers (Provider → UseCase → Repository)

---

## Best Practices

✅ **Do:**
- Test business logic, not implementation details
- Use descriptive test names
- Follow AAA pattern consistently
- Test edge cases and error conditions
- Mock external dependencies
- Keep tests isolated and independent

❌ **Don't:**
- Test Flutter framework code
- Test UI widgets in unit tests (use widget tests instead)
- Make tests dependent on each other
- Test implementation details
- Skip edge cases

---

## Total Test Coverage

- **Total Tests**: 35 test cases ✅
- **CharacterSearchProvider**: 7 tests
- **FavoriteProvider**: 12 tests  
- **CharacterRepository**: 16 tests
- **Coverage Areas**: 
  - State management
  - Business logic
  - Error handling
  - Data operations
  - Filter/Search functionality
  - Favorite caching

---

## Future Test Improvements

- [ ] Add widget tests for UI components
- [ ] Add integration tests for full user flows
- [ ] Increase code coverage to 80%+
- [ ] Add performance tests
- [ ] Add golden tests for UI consistency

---

## Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
```

---

## Troubleshooting

**Issue**: Tests fail with "Missing stub" error
**Solution**: Register fallback values for custom types:
```dart
setUpAll(() {
  registerFallbackValue(FakeCharacter());
});
```

**Issue**: Async tests timeout
**Solution**: Add timeout to test or increase default timeout:
```dart
test('my test', () async {
  // test code
}, timeout: Timeout(Duration(seconds: 10)));
```

---

Made with ❤️ for Rick and Morty fans
