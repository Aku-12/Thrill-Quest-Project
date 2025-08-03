// test/features/home/domain/usecase/update_activity_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/features/home/domain/use_case/update_activity_usecase.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}

void main() {
  late MockActivityRepository mockRepository;
  late UpdateActivityUseCase useCase;

  setUp(() {
    mockRepository = MockActivityRepository();
    useCase = UpdateActivityUseCase(repository: mockRepository);
  });

  const tId = 'activity-123';
  const tActivity = ActivityEntity(
    id: tId,
    name: 'Canyoning',
    location: 'Sundarijal',
    images: ['canyon.jpg'],
    price: 150.0,
    duration: '4 hours',
    difficulty: 'Advanced',
    bookings: 20,
    rating: 4.7,
    status: 'Active',
  );

  const tParams = UpdateActivityParams(id: tId, activity: tActivity);

  group('UpdateActivityParams', () {
    test('should support value comparison using Equatable', () {
      const anotherParams = UpdateActivityParams(id: tId, activity: tActivity);
      expect(tParams, anotherParams);
      expect(tParams.props, [tId, tActivity]);
    });
  });

  group('UpdateActivityUseCase', () {
    test('should be instantiated properly with repository', () {
      expect(useCase, isA<UpdateActivityUseCase>());
      expect(useCase.repository, mockRepository);
    });

    test('should return Right(void) when update is successful', () async {
      // Arrange
      when(() => mockRepository.updateActivity(tId, tActivity))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(tParams);

      // Assert
      verify(() => mockRepository.updateActivity(tId, tActivity)).called(1);
      expect(result, const Right(null));
    });

    test('should return Left(Failure) when update fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Update failed');
      when(() => mockRepository.updateActivity(tId, tActivity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(tParams);

      // Assert
      verify(() => mockRepository.updateActivity(tId, tActivity)).called(1);
      expect(result, Left(failure));
    });
  });
}
