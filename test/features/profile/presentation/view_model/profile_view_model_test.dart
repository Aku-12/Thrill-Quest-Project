import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';
import 'package:thrill_quest/features/profile/domain/use_case/get_user_profile_usecase.dart';
import 'package:thrill_quest/features/profile/domain/use_case/update_user_profile_usecase.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_event.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_state.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_view_model.dart';

// ------------------- Mocks ------------------------

class MockGetUserProfileUsecase extends Mock implements GetUserProfileUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockFile extends Mock implements File {}

class FakeUpdateProfileParams extends Fake implements UpdateProfileParams {}

void main() {
  late MockGetUserProfileUsecase mockGetUserProfileUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;

  setUpAll(() {
    registerFallbackValue(FakeUpdateProfileParams());
  });

  setUp(() {
    mockGetUserProfileUsecase = MockGetUserProfileUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
  });

  final testUser = UserEntity(
    id: '1',
    fName: 'Test',
    lName: 'User',
    email: 'test@example.com',
    phoneNo: '1234567890',
    profileImage: 'url_to_image',
  );

  group('ProfileViewModel Tests', () {
    blocTest<ProfileViewModel, ProfileState>(
      'emits [loading, success] when FetchUserProfileEvent succeeds',
      build: () {
        when(() => mockGetUserProfileUsecase()).thenAnswer(
          (_) async => Right(testUser),
        );
        return ProfileViewModel(
          getUserProfileUsecase: mockGetUserProfileUsecase,
          updateUserProfileUsecase: mockUpdateProfileUsecase,
        );
      },
      act: (bloc) => bloc.add(FetchUserProfileEvent()),
      expect: () => [
        ProfileState(status: ProfileStatus.loading),
        ProfileState(
          status: ProfileStatus.success,
          user: testUser,
          imageFile: null,
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits [loading, failure] when FetchUserProfileEvent fails',
      build: () {
        when(() => mockGetUserProfileUsecase()).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Error')),
        );
        return ProfileViewModel(
          getUserProfileUsecase: mockGetUserProfileUsecase,
          updateUserProfileUsecase: mockUpdateProfileUsecase,
        );
      },
      act: (bloc) => bloc.add(FetchUserProfileEvent()),
      expect: () => [
        ProfileState(status: ProfileStatus.loading),
        ProfileState(
          status: ProfileStatus.failure,
          error: const ApiFailure(message: 'Error'),
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits [loading, saved, loading, success] when SaveChangesEvent succeeds',
      build: () {
        when(() => mockUpdateProfileUsecase.call(any())).thenAnswer(
          (_) async => Right(testUser),
        );
        when(() => mockGetUserProfileUsecase()).thenAnswer(
          (_) async => Right(testUser),
        );
        return ProfileViewModel(
          getUserProfileUsecase: mockGetUserProfileUsecase,
          updateUserProfileUsecase: mockUpdateProfileUsecase,
        );
      },
      seed: () => ProfileState(user: testUser),
      act: (bloc) => bloc.add(SaveChangesEvent(
        name: 'Test User',
        email: 'test@example.com',
        phone: '1234567890',
      )),
      expect: () => [
        ProfileState(user: testUser, status: ProfileStatus.loading),
        ProfileState(user: testUser, status: ProfileStatus.saved),
        ProfileState(status: ProfileStatus.loading, user: testUser),
        ProfileState(status: ProfileStatus.success, user: testUser),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits [failure] when SaveChangesEvent is called but user is null',
      build: () => ProfileViewModel(
        getUserProfileUsecase: mockGetUserProfileUsecase,
        updateUserProfileUsecase: mockUpdateProfileUsecase,
      ),
      act: (bloc) => bloc.add(SaveChangesEvent(
        name: 'Test User',
        email: 'test@example.com',
        phone: '1234567890',
      )),
      expect: () => [
        ProfileState(
          status: ProfileStatus.failure,
          error: const ApiFailure(message: 'User not loaded'),
        ),
      ],
    );
  });
}
