// test/features/favorites/domain/usecase/remove_from_favorites_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/remove_from_favorite.dart';

// Mock repository
class MockFavoritesRepository extends Mock implements IFavoritesRepository {}

void main() {
  late RemoveFromFavoritesUseCase usecase;
  late MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    usecase = RemoveFromFavoritesUseCase(mockFavoritesRepository);
  });

  group('RemoveFromFavoritesParams', () {
    test('should instantiate with correct activityId', () {
      const activityId = 'abc123';
      final params = RemoveFromFavoritesParams(activityId: activityId);
      expect(params.activityId, activityId);
    });

    test('should compare equal params with same activityId', () {
      const activityId = 'abc123';
      final p1 = RemoveFromFavoritesParams(activityId: activityId);
      final p2 = RemoveFromFavoritesParams(activityId: activityId);
      expect(p1, p2);
    });
  });

  group('RemoveFromFavoritesUseCase', () {
    const activityId = 'abc123';

    test('should create usecase with provided repository', () {
      expect(usecase, isA<RemoveFromFavoritesUseCase>());
    });

    test('should call repository.removeFromFavorites with correct activityId and return success', () async {
      // Arrange
      when(() => mockFavoritesRepository.removeFromFavorites(activityId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase.call(RemoveFromFavoritesParams(activityId: activityId));

      // Assert
      verify(() => mockFavoritesRepository.removeFromFavorites(activityId)).called(1);
      expect(result, const Right(null));
    });

    test('should return failure when repository returns failure', () async {
      // Arrange
      final failure = ApiFailure(message: 'Failed to remove favorite');

      when(() => mockFavoritesRepository.removeFromFavorites(activityId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase.call(RemoveFromFavoritesParams(activityId: activityId));

      // Assert
      verify(() => mockFavoritesRepository.removeFromFavorites(activityId)).called(1);
      expect(result, Left(failure));
    });
  });
}
