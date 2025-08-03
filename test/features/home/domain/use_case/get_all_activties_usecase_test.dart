// test/features/home/domain/usecase/get_all_activities_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/features/home/domain/use_case/get_all_activties_usecase.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}

void main() {
  late MockActivityRepository mockRepository;
  late GetAllActivitiesUseCase useCase;

  setUp(() {
    mockRepository = MockActivityRepository();
    useCase = GetAllActivitiesUseCase(repository: mockRepository);
  });

  const tActivities = [
    ActivityEntity(
      id: '1',
      name: 'Rafting',
      location: 'Trishuli',
      images: ['raft.jpg'],
      price: 90.0,
      duration: '3 hours',
      difficulty: 'Beginner',
      bookings: 45,
      rating: 4.5,
      status: 'Active',
    ),
    ActivityEntity(
      id: '2',
      name: 'Paragliding',
      location: 'Pokhara',
      images: ['para.jpg'],
      price: 120.0,
      duration: '2 hours',
      difficulty: 'Intermediate',
      bookings: 100,
      rating: 4.8,
      status: 'Active',
    ),
  ];

  group('GetAllActivitiesUseCase', () {
    test('should return list of ActivityEntity when repository returns data', () async {
      // Arrange
      when(() => mockRepository.getAllActivities())
          .thenAnswer((_) async => const Right(tActivities));

      // Act
      final result = await useCase();

      // Assert
      verify(() => mockRepository.getAllActivities()).called(1);
      expect(result, const Right(tActivities));
    });

    test('should return Failure when repository fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Server Error');
      when(() => mockRepository.getAllActivities())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase();

      // Assert
      verify(() => mockRepository.getAllActivities()).called(1);
      expect(result, Left(failure));
    });
  });
}
