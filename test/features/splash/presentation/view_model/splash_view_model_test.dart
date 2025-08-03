import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_event.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_state.dart';
import 'package:thrill_quest/features/splash/presentation/view_model/splash_view_model.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('SplashViewModel', () {
    blocTest<SplashViewModel, SplashState>(
      'emits [AuthenticatedUser] when token is not null',
      build: () {
        when(() => mockAuthService.getToken())
            .thenAnswer((_) async => 'valid_token');
        return SplashViewModel(authService: mockAuthService);
      },
      act: (bloc) => bloc.add(AppStart()),
      expect: () => [isA<AuthenticatedUser>()],
    );

    blocTest<SplashViewModel, SplashState>(
      'emits [UnAuthenticatedUser] when token is null',
      build: () {
        when(() => mockAuthService.getToken()).thenAnswer((_) async => null);
        return SplashViewModel(authService: mockAuthService);
      },
      act: (bloc) => bloc.add(AppStart()),
      expect: () => [isA<UnAuthenticatedUser>()],
    );
  });
}
