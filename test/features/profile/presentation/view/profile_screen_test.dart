import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:thrill_quest/features/profile/presentation/view/profile_screen.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_state.dart';
import 'package:thrill_quest/features/auth/domain/entity/user_entity.dart';

class MockProfileViewModel extends Mock implements ProfileViewModel {}

void main() {
  late MockProfileViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockProfileViewModel();
  });

  final user = UserEntity(
    id: '1',
    fName: 'John',
    lName: 'Doe',
    email: 'john@example.com',
    phoneNo: '9876543210',
    profileImage: '',
  );

  testWidgets('Displays CircularProgressIndicator when loading without user', (tester) async {
  when(() => mockViewModel.state).thenReturn(ProfileState(status: ProfileStatus.loading));
  when(() => mockViewModel.stream).thenAnswer((_) => Stream.value(ProfileState(status: ProfileStatus.loading)));

  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<ProfileViewModel>.value(
        value: mockViewModel,
        child: const ProfileScreen(),
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});


  testWidgets('Displays error message when user is null and not loading', (tester) async {
  when(() => mockViewModel.state)
      .thenReturn(ProfileState(status: ProfileStatus.failure));
  when(() => mockViewModel.stream)
      .thenAnswer((_) => const Stream<ProfileState>.empty());

  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<ProfileViewModel>.value(
        value: mockViewModel,
        child: const ProfileScreen(),
      ),
    ),
  );

  await tester.pumpAndSettle();

  expect(find.text('Could not load profile.'), findsOneWidget);
});

}