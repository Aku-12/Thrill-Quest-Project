// test/features/home/presentation/view_model/booking_view_model_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:thrill_quest/features/bookings/domain/use_case/create_booking_usecase.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_event.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_state.dart';
import 'package:thrill_quest/features/guides/domain/use_case/get_all_guides_usecase.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

// Mock classes
class MockCreateBookingUsecase extends Mock implements CreateBookingUsecase {}
class MockGetAllGuidesUsecase extends Mock implements GetAllGuidesUsecase {}
class MockAuthService extends Mock implements AuthService {}

// Fake classes for fallback values
class FakeGetAllGuidesParams extends Fake implements GetAllGuidesParams {}
class FakeBookingsEntity extends Fake implements BookingsEntity {}

void main() {
  late MockCreateBookingUsecase mockCreateBookingUsecase;
  late MockGetAllGuidesUsecase mockGetAllGuidesUsecase;
  late MockAuthService mockAuthService;
  late BookingViewModel bookingViewModel;

  final fakeUser = UserEntity(
    id: 'user123',
    fName: 'John',
    lName: 'Doe',
    email: 'john@example.com',
  );

  setUpAll(() {
    registerFallbackValue(FakeGetAllGuidesParams());
    registerFallbackValue(FakeBookingsEntity());
  });

  setUp(() {
    mockCreateBookingUsecase = MockCreateBookingUsecase();
    mockGetAllGuidesUsecase = MockGetAllGuidesUsecase();
    mockAuthService = MockAuthService();

    when(() => mockAuthService.getUser()).thenAnswer((_) async => fakeUser);

    bookingViewModel = BookingViewModel(
      createBookingUsecase: mockCreateBookingUsecase,
      getAllGuidesUsecase: mockGetAllGuidesUsecase,
      authService: mockAuthService,
    );
  });

  blocTest<BookingViewModel, BookingState>(
    'emits updated state when ActivitySelected is added',
    build: () => bookingViewModel,
    act: (bloc) => bloc.add(ActivitySelected(activityId: '123', activityName: 'Sky Dive')),
    expect: () => [
      bookingViewModel.state.copyWith(
        selectedActivityId: '123',
        selectedActivityName: 'Sky Dive',
        errorMessage: null,
      ),
    ],
  );

  blocTest<BookingViewModel, BookingState>(
    'emits updated state when GuideSelected is added',
    build: () => bookingViewModel,
    act: (bloc) => bloc.add(GuideSelected('Guide A')),
    expect: () => [
      bookingViewModel.state.copyWith(
        selectedGuide: 'Guide A',
        errorMessage: null,
      ),
    ],
  );

  blocTest<BookingViewModel, BookingState>(
    'emits updated state when DateSelected is added',
    build: () => bookingViewModel,
    act: (bloc) => bloc.add(DateSelected(DateTime(2025, 10, 5))),
    expect: () => [
      bookingViewModel.state.copyWith(
        selectedDate: DateTime(2025, 10, 5),
        errorMessage: null,
      ),
    ],
  );

  blocTest<BookingViewModel, BookingState>(
    'SubmitBooking fails when booking details are missing',
    build: () => bookingViewModel,
    act: (bloc) => bloc.add(SubmitBooking('')),
    expect: () => [
      bookingViewModel.state.copyWith(
        errorMessage: 'Please fill all booking details.',
        isLoading: false,
        bookingSuccess: false,
      ),
    ],
  );

  blocTest<BookingViewModel, BookingState>(
    'SubmitBooking succeeds when all valid data is provided',
    build: () {
      when(() => mockCreateBookingUsecase.call(any()))
          .thenAnswer((_) async => const Right(null));
      return bookingViewModel;
    },
    seed: () => bookingViewModel.state.copyWith(
      selectedActivityName: 'Paragliding',
      selectedGuide: 'Guide A',
      selectedDate: DateTime(2025, 10, 10),
    ),
    act: (bloc) => bloc.add(SubmitBooking('activity123')),
    expect: () => [
      bookingViewModel.state.copyWith(
        isLoading: true,
        errorMessage: null,
        bookingSuccess: false,
      ),
      bookingViewModel.state.copyWith(
        isLoading: false,
        bookingSuccess: true,
        errorMessage: null,
      ),
    ],
    verify: (_) {
      verify(() => mockAuthService.getUser()).called(1);
      verify(() => mockCreateBookingUsecase.call(any())).called(1);
    },
  );

  blocTest<BookingViewModel, BookingState>(
    'ResetBookingState resets success and error message',
    build: () => bookingViewModel,
    seed: () => bookingViewModel.state.copyWith(
      bookingSuccess: true,
      errorMessage: 'Some error',
    ),
    act: (bloc) => bloc.add(ResetBookingState()),
    expect: () => [
      bookingViewModel.state.copyWith(
        bookingSuccess: false,
        errorMessage: null,
      ),
    ],
  );
}
