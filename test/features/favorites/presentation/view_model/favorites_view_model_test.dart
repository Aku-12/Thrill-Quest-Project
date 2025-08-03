import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/add_to_favorite_usecase.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/get_favorites_usecase.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/remove_from_favorite.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_event.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_state.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_view_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';

// Mock classes
class MockGetFavoritesUseCase extends Mock implements GetFavoritesUseCase {}
class MockAddToFavoritesUseCase extends Mock implements AddToFavoritesUseCase {}
class MockRemoveFromFavoritesUseCase extends Mock implements RemoveFromFavoritesUseCase {}

void main() {
  late FavoritesViewModel favoritesViewModel;
  late MockGetFavoritesUseCase mockGetFavoritesUseCase;
  late MockAddToFavoritesUseCase mockAddToFavoritesUseCase;
  late MockRemoveFromFavoritesUseCase mockRemoveFromFavoritesUseCase;

  setUp(() {
    mockGetFavoritesUseCase = MockGetFavoritesUseCase();
    mockAddToFavoritesUseCase = MockAddToFavoritesUseCase();
    mockRemoveFromFavoritesUseCase = MockRemoveFromFavoritesUseCase();

    favoritesViewModel = FavoritesViewModel(
      getFavoritesUseCase: mockGetFavoritesUseCase,
      addToFavoritesUseCase: mockAddToFavoritesUseCase,
      removeFromFavoritesUseCase: mockRemoveFromFavoritesUseCase,
    );

    // Register fallback values if needed for parameters used in mocks
    registerFallbackValue(AddToFavoritesParams(activity: ActivityApiModel(id: '0', name: '', location: '', price: 0, duration: '', difficulty: '', bookings: 0, rating: 0, status: '')));
    registerFallbackValue(RemoveFromFavoritesParams(activityId: ''));
  });

  final tActivity = ActivityApiModel(
    id: '1',
    name: 'Paragliding',
    location: 'Pokhara',
    price: 3000,
    duration: '1 hour',
    difficulty: 'Intermediate',
    bookings: 15,
    rating: 4.9,
    status: 'Active',
  );

  final tFavorites = [tActivity];

  group('FetchFavoritesEvent', () {
    blocTest<FavoritesViewModel, FavoritesState>(
      'emits [FavoritesLoading, FavoritesLoaded] when favorites are fetched successfully',
      build: () {
        when(() => mockGetFavoritesUseCase())
            .thenAnswer((_) async => Right(tFavorites));
        return favoritesViewModel;
      },
      act: (bloc) => bloc.add(const FetchFavoritesEvent()),
      expect: () => [
        const FavoritesLoading(),
        FavoritesLoaded(favorites: tFavorites),
      ],
      verify: (_) {
        verify(() => mockGetFavoritesUseCase()).called(1);
      },
    );

    blocTest<FavoritesViewModel, FavoritesState>(
      'emits [FavoritesLoading, FavoritesError] when fetching favorites fails',
      build: () {
        when(() => mockGetFavoritesUseCase())
            .thenAnswer((_) async => Left(const ApiFailure(message: 'Failed to fetch')));
        return favoritesViewModel;
      },
      act: (bloc) => bloc.add(const FetchFavoritesEvent()),
      expect: () => [
        const FavoritesLoading(),
        const FavoritesError(message: 'Failed to fetch'),
      ],
      verify: (_) {
        verify(() => mockGetFavoritesUseCase()).called(1);
      },
    );
  });

  group('AddToFavoritesEvent', () {
    blocTest<FavoritesViewModel, FavoritesState>(
      'calls addToFavoritesUseCase and then triggers FetchFavoritesEvent',
      build: () {
        when(() => mockAddToFavoritesUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetFavoritesUseCase())
            .thenAnswer((_) async => Right(tFavorites));
        return favoritesViewModel;
      },
      act: (bloc) => bloc.add(AddToFavoritesEvent(tActivity)),
      expect: () => [
        // Because FetchFavoritesEvent is added internally after adding, it emits loading and loaded states
        const FavoritesLoading(),
        FavoritesLoaded(favorites: tFavorites),
      ],
      verify: (_) {
        verify(() => mockAddToFavoritesUseCase(AddToFavoritesParams(activity: tActivity))).called(1);
        verify(() => mockGetFavoritesUseCase()).called(1);
      },
    );
  });

  group('RemoveFromFavoritesEvent', () {
    blocTest<FavoritesViewModel, FavoritesState>(
      'calls removeFromFavoritesUseCase and then triggers FetchFavoritesEvent',
      build: () {
        when(() => mockRemoveFromFavoritesUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetFavoritesUseCase())
            .thenAnswer((_) async => Right(tFavorites));
        return favoritesViewModel;
      },
      act: (bloc) => bloc.add(const RemoveFromFavoritesEvent('1')),
      expect: () => [
        // Because FetchFavoritesEvent is added internally after removing, it emits loading and loaded states
        const FavoritesLoading(),
        FavoritesLoaded(favorites: tFavorites),
      ],
      verify: (_) {
        verify(() => mockRemoveFromFavoritesUseCase(RemoveFromFavoritesParams(activityId: '1'))).called(1);
        verify(() => mockGetFavoritesUseCase()).called(1);
      },
    );
  });
}
