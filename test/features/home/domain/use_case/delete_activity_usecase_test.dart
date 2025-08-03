// test/features/home/domain/usecase/delete_activity_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/features/home/domain/use_case/delete_activity_usecase.dart';

// Mock repository
class MockActivityRepository extends Mock implements IActivityRepository {}

void main() {
  late MockActivityRepository mockRepository;
  late DeleteActivityUseCase useCase;

  setUp(() {
    mockRepository = MockActivityRepository();
    useCase = DeleteActivityUseCase(repository: mockRepository);
  });

  const testId = 'activity-123';
  const params = DeleteActivityParams(id: testId);

  group('DeleteActivityUseCase', () {
    test('should call deleteActivity on the repository and return success', () async {
      // Arrange
      when(() => mockRepository.deleteActivity(testId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(params);

      // Assert
      verify(() => mockRepository.deleteActivity(testId)).called(1);
      expect(result, const Right(null));
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Unable to delete activity');
      when(() => mockRepository.deleteActivity(testId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      verify(() => mockRepository.deleteActivity(testId)).called(1);
      expect(result, Left(failure));
    });

    test('DeleteActivityParams should support value equality', () {
      const p1 = DeleteActivityParams(id: testId);
      const p2 = DeleteActivityParams(id: testId);
      expect(p1, equals(p2));
      expect(p1.props, [testId]);
    });
  });
}
