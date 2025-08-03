// test/features/favorites/domain/usecase/add_to_favorites_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/add_to_favorite_usecase.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';

// Mock repository
class MockFavoritesRepository extends Mock implements IFavoritesRepository {}

void main() {
  late AddToFavoritesUseCase usecase;
  late MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    usecase = AddToFavoritesUseCase(mockFavoritesRepository);
  });

  group('AddToFavoritesParams', () {
    test('should instantiate with correct activity', () {
      final activity = ActivityApiModel(
        id: '1',
        name: 'Rafting',
        location: 'Pokhara',
        images: ['url1', 'url2'],
        price: 100.0,
        duration: '3 hours',
        difficulty: 'Medium',
        bookings: 10,
        rating: 4.5,
        status: 'active',
      );

      final params = AddToFavoritesParams(activity: activity);
      expect(params.activity, activity);
    });

    test('should compare equal params with same activity', () {
      final activity = ActivityApiModel(
        id: '1',
        name: 'Rafting',
        location: 'Pokhara',
        images: ['url1', 'url2'],
        price: 100.0,
        duration: '3 hours',
        difficulty: 'Medium',
        bookings: 10,
        rating: 4.5,
        status: 'active',
      );

      final p1 = AddToFavoritesParams(activity: activity);
      final p2 = AddToFavoritesParams(activity: activity);

      expect(p1, p2);
    });
  });

  group('AddToFavoritesUseCase', () {
    final activity = ActivityApiModel(
      id: '1',
      name: 'Rafting',
      location: 'Pokhara',
      images: ['url1', 'url2'],
      price: 100.0,
      duration: '3 hours',
      difficulty: 'Medium',
      bookings: 10,
      rating: 4.5,
      status: 'active',
    );

    test('should create usecase with provided repository', () {
      expect(usecase, isA<AddToFavoritesUseCase>());
    });

    test('should call repository.addToFavorites with correct activity and return success', () async {
      // Arrange
      when(() => mockFavoritesRepository.addToFavorites(activity))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase.call(AddToFavoritesParams(activity: activity));

      // Assert
      verify(() => mockFavoritesRepository.addToFavorites(activity)).called(1);
      expect(result, const Right(null));
    });

    test('should return failure when repository returns failure', () async {
      // Arrange
      final failure = ApiFailure(message: 'Failed to add favorite');

      when(() => mockFavoritesRepository.addToFavorites(activity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase.call(AddToFavoritesParams(activity: activity));

      // Assert
      verify(() => mockFavoritesRepository.addToFavorites(activity)).called(1);
      expect(result, Left(failure));
    });
  });
}
