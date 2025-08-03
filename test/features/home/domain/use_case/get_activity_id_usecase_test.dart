// test/features/home/domain/usecase/get_activity_by_id_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/features/home/domain/use_case/get_activity_id_usecase.dart';

// Mock class
class MockActivityRepository extends Mock implements IActivityRepository {}

void main() {
  late MockActivityRepository mockRepository;
  late GetActivityByIdUseCase useCase;

  setUp(() {
    mockRepository = MockActivityRepository();
    useCase = GetActivityByIdUseCase(repository: mockRepository);
  });

  const tId = 'activity-001';
  const tParams = GetActivityByIdParams(id: tId);

  const tActivity = ActivityEntity(
    id: tId,
    name: 'Paragliding',
    location: 'Pokhara',
    images: ['img1.jpg'],
    price: 120.0,
    duration: '2 hours',
    difficulty: 'Intermediate',
    bookings: 100,
    rating: 4.8,
    status: 'Active',
  );

  group('GetActivityByIdUseCase', () {
    test('should return ActivityEntity when repository returns data', () async {
      // Arrange
      when(() => mockRepository.getActivityById(tId))
          .thenAnswer((_) async => const Right(tActivity));

      // Act
      final result = await useCase(tParams);

      // Assert
      verify(() => mockRepository.getActivityById(tId)).called(1);
      expect(result, const Right(tActivity));
    });

    test('should return Failure when repository returns failure', () async {
      // Arrange
      final failure = ApiFailure(message: 'Activity not found');
      when(() => mockRepository.getActivityById(tId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(tParams);

      // Assert
      verify(() => mockRepository.getActivityById(tId)).called(1);
      expect(result, Left(failure));
    });

    test('GetActivityByIdParams should support value equality', () {
      const p1 = GetActivityByIdParams(id: tId);
      const p2 = GetActivityByIdParams(id: tId);
      expect(p1, equals(p2));
      expect(p1.props, [tId]);
    });
  });
}
