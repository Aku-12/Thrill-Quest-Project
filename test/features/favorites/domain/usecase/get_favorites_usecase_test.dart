// test/features/favorites/domain/usecase/get_favorites_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/get_favorites_usecase.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';

// Mock repository
class MockFavoritesRepository extends Mock implements IFavoritesRepository {}

void main() {
  late GetFavoritesUseCase usecase;
  late MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    usecase = GetFavoritesUseCase(favoritesRepository: mockFavoritesRepository);
  });

  final tActivityList = [
    ActivityApiModel(
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
    ),
    ActivityApiModel(
      id: '2',
      name: 'Paragliding',
      location: 'Pokhara',
      images: ['url3'],
      price: 150.0,
      duration: '2 hours',
      difficulty: 'Hard',
      bookings: 5,
      rating: 4.8,
      status: 'active',
    ),
  ];

  group('GetFavoritesUseCase', () {
    test('should create usecase with the provided repository', () {
      expect(usecase, isA<GetFavoritesUseCase>());
    });

    test('should call fetchFavorites on repository and return list of activities on success', () async {
      // Arrange
      when(() => mockFavoritesRepository.fetchFavorites())
          .thenAnswer((_) async => Right(tActivityList));

      // Act
      final result = await usecase.call();

      // Assert
      verify(() => mockFavoritesRepository.fetchFavorites()).called(1);
      expect(result, Right(tActivityList));
    });

    test('should return failure when repository returns failure', () async {
      // Arrange
      final failure = ApiFailure(message: 'Failed to fetch favorites');

      when(() => mockFavoritesRepository.fetchFavorites())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase.call();

      // Assert
      verify(() => mockFavoritesRepository.fetchFavorites()).called(1);
      expect(result, Left(failure));
    });
  });
}
