// test/features/home/domain/usecase/create_activity_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/features/home/domain/use_case/create_activity_usecase.dart';

// Mock repository
class MockActivityRepository extends Mock implements IActivityRepository {}

void main() {
  late CreateActivityUseCase usecase;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    usecase = CreateActivityUseCase(repository: mockRepository);
  });

  group('CreateActivityParams', () {
    final activity = ActivityEntity(
      id: '1',
      name: 'Bungee Jumping',
      location: 'Pokhara',
      price: 4500.0,
      duration: '2 hours',
      images: ['img1.png'],
      difficulty: 'Advanced',
      bookings: 100,
      rating: 4.8,
      status: 'Active',
    );

    test('should support value equality', () {
      final p1 = CreateActivityParams(activity: activity);
      final p2 = CreateActivityParams(activity: activity);

      expect(p1, equals(p2));
    });

    test('should contain correct activity data', () {
      final params = CreateActivityParams(activity: activity);
      expect(params.activity.name, 'Bungee Jumping');
      expect(params.activity.difficulty, 'Advanced');
      expect(params.activity.bookings, 100);
      expect(params.activity.status, 'Active');
    });
  });

  group('CreateActivityUseCase', () {
    final activity = ActivityEntity(
      id: '2',
      name: 'Paragliding',
      location: 'Pokhara',
      price: 3000.0,
      duration: '1 hour',
      images: ['paragliding.png'],
      difficulty: 'Beginner',
      bookings: 200,
      rating: 4.9,
      status: 'Active',
    );

    final params = CreateActivityParams(activity: activity);

    test('should be an instance of CreateActivityUseCase', () {
      expect(usecase, isA<CreateActivityUseCase>());
    });

    test('should call createActivity on repository and return success', () async {
      // Arrange
      when(() => mockRepository.createActivity(activity))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase.call(params);

      // Assert
      verify(() => mockRepository.createActivity(activity)).called(1);
      expect(result, const Right(null));
    });

    test('should return failure when repository throws', () async {
      // Arrange
      final failure = ApiFailure(message: 'Something went wrong');

      when(() => mockRepository.createActivity(activity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase.call(params);

      // Assert
      verify(() => mockRepository.createActivity(activity)).called(1);
      expect(result, Left(failure));
    });
  });
}
