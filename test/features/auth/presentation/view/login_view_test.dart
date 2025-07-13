import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:thrill_quest/features/auth/presentation/view/login_view.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:thrill_quest/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:thrill_quest/features/home/presentation/view/home_screen.dart';

// Mock LoginViewModel Bloc
class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

// Mock NavigatorObserver for navigation verification
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Fake LoginEvent for mocktail fallback value registration
class FakeLoginEvent extends Fake implements LoginEvent {}

// Fake Route<dynamic> for mocktail fallback value registration
class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  // Register fallback values for mocktail so it can handle any() on these types
  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeRoute());
  });

  late MockLoginBloc loginBloc;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    loginBloc = MockLoginBloc();
    mockObserver = MockNavigatorObserver();
    when(() => loginBloc.state).thenReturn(const LoginState());
    // Stub the stream getter to avoid null stream error in widget listening
    when(() => loginBloc.stream).thenAnswer((_) => const Stream<LoginState>.empty());
  });

  Widget createTestWidget({NavigatorObserver? observer}) {
    return MaterialApp(
      home: BlocProvider<LoginViewModel>.value(
        value: loginBloc,
        child: LoginScreen(),
      ),
      routes: {
        '/signup': (context) => const Scaffold(body: Text("Signup Screen")),
      },
      navigatorObservers: observer != null ? [observer] : [],
    );
  }

  testWidgets('LoginScreen renders UI components', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    final signUpText = find.byWidgetPredicate(
      (widget) =>
          widget is RichText && widget.text.toPlainText().contains('Sign Up'),
    );
    expect(signUpText, findsOneWidget);
  });

  testWidgets('Displays validation errors if fields are empty', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Tapping Sign Up navigates to Signup screen', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final signUpText = find.byWidgetPredicate(
      (widget) =>
          widget is RichText && widget.text.toPlainText().contains('Sign Up'),
    );

    await tester.tap(signUpText);
    await tester.pumpAndSettle();

    expect(find.text('Signup Screen'), findsOneWidget);
  });

  testWidgets('Does not show errors when valid input is entered', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@mail.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsNothing);
    expect(find.text('Please enter your password'), findsNothing);
  });

  testWidgets('Forgot Password button can be tapped', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot Password?'));
    await tester.pump();

    // No crash means test passes and coverage increases
  });

  testWidgets('Login button adds LoginSubmitted event on valid form', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@mail.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    verify(() => loginBloc.add(any(that: isA<LoginSubmitted>()))).called(1);
  });

  testWidgets('Navigates to HomeScreen on successful login', (tester) async {
    when(() => loginBloc.stream).thenAnswer((_) => Stream.fromIterable([
      const LoginState(),
      const LoginState(formStatus: FormStatus.success, message: "Login Successful!"),
    ]));
    when(() => loginBloc.state).thenReturn(const LoginState());

    await tester.pumpWidget(createTestWidget(observer: mockObserver));
    await tester.pumpAndSettle();

    // Verify that navigation push happened at least once
    verify(() => mockObserver.didPush(any(), any())).called(greaterThanOrEqualTo(1));

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
