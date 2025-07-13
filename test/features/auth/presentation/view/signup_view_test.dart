import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:thrill_quest/features/auth/presentation/view/signup_view.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

// Mock Signup Bloc
class MockSignupBloc extends MockBloc<SignupEvent, SignupState>
    implements SignupViewModel {}

class FakeSignupEvent extends Fake implements SignupEvent {}

void main() {
  late MockSignupBloc signupBloc;

  setUpAll(() {
    registerFallbackValue(FakeSignupEvent());
  });

  setUp(() {
    signupBloc = MockSignupBloc();
    when(() => signupBloc.state).thenReturn(SignupState());
    when(() => signupBloc.stream)
        .thenAnswer((_) => const Stream<SignupState>.empty());
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(1200, 2000)),
        child: BlocProvider<SignupViewModel>.value(
          value: signupBloc,
          child: SignupView(),
        ),
      ),
      routes: {
        '/login': (context) => const Scaffold(body: Text('Login Screen')),
      },
    );
  }

  testWidgets('Renders all signup form fields and buttons', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign up to get started'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'First Name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Last Name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Phone Number'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);

    final richText = find.byWidgetPredicate((widget) {
      return widget is RichText &&
          widget.text.toPlainText().contains('Already have an account?');
    });
    expect(richText, findsOneWidget);
  });

  testWidgets('Displays validation errors when fields are empty',
      (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your first name'), findsOneWidget);
    expect(find.text('Please enter your last name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your phone number'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Shows password length error when password is too short',
      (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '123');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('Dispatches OnSubmittedEvent when form is valid',
      (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'First Name'), 'John');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Last Name'), 'Doe');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number'), '1234567890');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'securepass');

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();

    verify(
      () => signupBloc.add(
        any(
          that: isA<OnSubmittedEvent>()
              .having((e) => e.fName, 'fName', 'John')
              .having((e) => e.lName, 'lName', 'Doe')
              .having((e) => e.email, 'email', 'john@example.com')
              .having((e) => e.phoneNo, 'phoneNo', '1234567890')
              .having((e) => e.password, 'password', 'securepass'),
        ),
      ),
    ).called(1);
  });

    testWidgets('Tapping Login navigates to Login screen', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Find the GestureDetector that wraps the RichText
    final loginGestureFinder = find.byWidgetPredicate(
      (widget) =>
          widget is GestureDetector &&
          widget.child is RichText &&
          (widget.child as RichText)
              .text
              .toPlainText()
              .contains('Already have an account?'),
    );

    expect(loginGestureFinder, findsOneWidget);

    // Ensure the GestureDetector is visible
    await tester.ensureVisible(loginGestureFinder);

    // Tap the gesture
    await tester.tap(loginGestureFinder);
    await tester.pumpAndSettle();

    // Verify navigation to Login Screen
    expect(find.text('Login Screen'), findsOneWidget);
  });
}