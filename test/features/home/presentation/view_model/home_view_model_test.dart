import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/use_case/get_all_activties_usecase.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_event.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_state.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_view_model.dart';

// Mock class for the use case
class MockGetAllActivitiesUseCase extends Mock implements GetAllActivitiesUseCase {}

void main() {
  late HomeViewModel homeViewModel;
  late MockGetAllActivitiesUseCase mockGetAllActivitiesUseCase;

  setUp(() {
    mockGetAllActivitiesUseCase = MockGetAllActivitiesUseCase();
    homeViewModel = HomeViewModel(getAllActivitiesUseCase: mockGetAllActivitiesUseCase);
  });

  final List<ActivityEntity> tActivities = [
    const ActivityEntity(
      id: '1',
      name: 'Paragliding',
      location: 'Pokhara',
      images: ['img1.jpg'],
      price: 100,
      duration: '2 hours',
      difficulty: 'Intermediate',
      bookings: 10,
      rating: 4.5,
      status: 'Active',
    ),
  ];

  group('HomeViewModel Tests', () {
    test('initial state should be HomeInitial', () {
      expect(homeViewModel.state, equals(const HomeInitial()));
    });

    blocTest<HomeViewModel, HomeState>(
      'emits [HomeLoading, HomeLoaded] when activities are fetched successfully',
      build: () {
        when(() => mockGetAllActivitiesUseCase())
            .thenAnswer((_) async => Right(tActivities));
        return homeViewModel;
      },
      act: (bloc) => bloc.add(const LoadActivities()),
      expect: () => [
        const HomeLoading(),
        HomeLoaded(activities: tActivities),
      ],
      verify: (_) {
        verify(() => mockGetAllActivitiesUseCase()).called(1);
      },
    );

    blocTest<HomeViewModel, HomeState>(
    'emits [HomeLoading, HomeError] with unexpected failure message',
    build: () {
      when(() => mockGetAllActivitiesUseCase())
          .thenAnswer((_) async => Left(ServerFailure(message: 'Unexpected failure')));
      return homeViewModel;
    },
    act: (bloc) => bloc.add(const LoadActivities()),
    expect: () => [
      const HomeLoading(),
      const HomeError(message: 'An unexpected error occurred.'),
    ],
  );

    blocTest<HomeViewModel, HomeState>(
      'emits [HomeLoading, HomeError] when an exception is thrown',
      build: () {
        when(() => mockGetAllActivitiesUseCase())
            .thenThrow(Exception('Unexpected Exception'));
        return homeViewModel;
      },
      act: (bloc) => bloc.add(const LoadActivities()),
      expect: () => [
        const HomeLoading(),
        HomeError(message: 'Exception: Unexpected Exception'),
      ],
    );
  });
}
